#!/bin/bash
set -e

echo "========================================"
echo "  DPM — Codespace Environment Setup"
echo "========================================"

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# [1/5] 安装系统依赖
echo "[1/5] 安装系统依赖..."
sudo apk add --no-cache mariadb mariadb-client redis

# 可选：安装 OpenJDK 17，用于兼容 Lombok 注解处理（仅在需要在脚本内运行 Maven 时）
echo "  （可选）安装 OpenJDK 17（用于 Lombok 兼容性）..."
sudo apk add --no-cache openjdk17

# 手动安装 Maven (避免 apk 拉 JDK 25 破坏 Lombok)
echo "  安装 Maven..."
if ! command -v mvn &> /dev/null; then
  MAVEN_VERSION=3.9.9
  curl -fsSL "https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
    | sudo tar xz -C /usr/local
  sudo ln -sf "/usr/local/apache-maven-${MAVEN_VERSION}/bin/mvn" /usr/local/bin/mvn
fi
 

# [2/5] 初始化并启动 MariaDB（更稳健）
echo "[2/5] 启动 MariaDB..."
if [ -d /var/lib/mysql/mysql ]; then
  echo "  mysql 数据目录已存在，跳过 initdb。"
else
  sudo mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db || true
fi

if pgrep -x mysqld >/dev/null 2>&1 || pgrep -f mariadbd >/dev/null 2>&1; then
  echo "  MariaDB 进程已存在，跳过启动。"
else
  sudo mariadbd-safe --user=mysql --datadir=/var/lib/mysql &
fi

for i in $(seq 1 30); do
  mysqladmin ping --silent >/dev/null 2>&1 && break
  sleep 1
done

# [3/5] 设置 root 密码并创建数据库（使用 sudo mariadb 以绕过 socket 授权）
echo "[3/5] 创建数据库 laigeoffer-pmhub..."
if sudo mariadb -e "select 1" >/dev/null 2>&1; then
  sudo mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('123456'); FLUSH PRIVILEGES;" >/dev/null 2>&1 || true
else
  echo "  无法通过正常方式连接到 MariaDB，尝试使用 --skip-grant-tables 临时启动以设置 root 密码..."
  # 尝试使用 --skip-grant-tables 启动一个临时实例
  sudo pkill -f mariadbd || true
  sudo mariadbd --skip-grant-tables --user=mysql --datadir=/var/lib/mysql &
  sleep 2
  for i in $(seq 1 20); do
    sudo mariadb -e "select 1" >/dev/null 2>&1 && break
    sleep 1
  done
  # 设置密码
  sudo mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '123456'; FLUSH PRIVILEGES;" >/dev/null 2>&1 || true
  # 重启正常实例
  sudo pkill -f mariadbd || true
  sleep 1
  sudo mariadbd-safe --user=mysql --datadir=/var/lib/mysql &
  for i in $(seq 1 30); do
    mysqladmin ping --silent >/dev/null 2>&1 && break
    sleep 1
  done
fi
sudo mariadb -u root -p123456 -e "CREATE DATABASE IF NOT EXISTS \`laigeoffer-pmhub\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >/dev/null 2>&1 || true

# [4/5] 导入 SQL（可见错误）
echo "[4/5] 导入表结构和初始数据..."
if [ -f "$PROJECT_ROOT/sql/init.sql" ]; then
  echo "  正在准备幂等化 SQL 导入文件..."
  TMP_SQL="/tmp/init_sql_$$.sql"
  # 使用 awk 进行更精确的幂等化转换：
  # 1) 将以 CREATE DATABASE 开头的语句改为 CREATE DATABASE IF NOT EXISTS
  # 2) 将以 INSERT INTO 开头的语句改为 INSERT IGNORE INTO
  awk 'BEGIN{IGNORECASE=1} \
    /^\s*CREATE[[:space:]]+DATABASE/ { sub(/CREATE[[:space:]]+DATABASE/, "CREATE DATABASE IF NOT EXISTS"); print; next } \
    /^\s*INSERT[[:space:]]+INTO/ { sub(/INSERT[[:space:]]+INTO/, "INSERT IGNORE INTO"); print; next } \
    { print }' "$PROJECT_ROOT/sql/init.sql" > "$TMP_SQL"

  # 兼容 MariaDB / 不同 MySQL 版本：统一字符集与 Collation（将 utf8mb3 替换为 utf8mb4）
  sed -i 's/utf8mb3/utf8mb4/g; s/utf8mb3_bin/utf8mb4_bin/g' "$TMP_SQL" || true

  # 清理可能的非法/不可见字节（例如 Navicat 导出的注释中出现的不可见字符）
  if command -v iconv >/dev/null 2>&1; then
    iconv -f utf-8 -t utf-8 -c "$TMP_SQL" -o "${TMP_SQL}.iconv" || true
    # 删除控制字符（保留换行与制表符）
    tr -d '\000-\010\013\014\016-\037' < "${TMP_SQL}.iconv" > "${TMP_SQL}.cleaned" || true
    mv "${TMP_SQL}.cleaned" "$TMP_SQL" || true
    rm -f "${TMP_SQL}.iconv" || true
  fi

  # 修复可能缺失的分号（确保 CREATE TABLE 的 ENGINE 行以分号结尾）
  TMP_SQL2="/tmp/init_sql_fixed_$$.sql"
  awk '{ if ($0 ~ /\) ENGINE/ && $0 !~ /;[[:space:]]*$/) { print $0 ";" } else print $0 }' "$TMP_SQL" > "$TMP_SQL2"

  # 额外清洗：确保所有 utf8mb3 被替换（忽略大小写），并删除替换字符/控制字符
  # 使用 perl 做更可靠的多行和不区分大小写替换与清洗
  perl -0777 -pe "s/utf8mb3/utf8mb4/gi; s/utf8mb3_bin/utf8mb4_bin/gi; s/COMMENT\s*'[^']*'//gi; s/\) ENGINE([^;\n]*)/\) ENGINE\1;/gi; s/(COLLATE[^;\n]*)/\1;/gi" -i "$TMP_SQL2" || true
  # 删除 Unicode 替换字符 U+FFFD 及控制字符（保留换行与制表）
  perl -CS -pe 's/\x{FFFD}//g; s/[\x00-\x08\x0B\x0C\x0E-\x1F]//g' -i "$TMP_SQL2" || true

  echo "  正在导入 SQL（幂等化，使用 --force 忽略可恢复错误）: $TMP_SQL2"
  if sudo mariadb --default-character-set=utf8mb4 --force -u root -p123456 laigeoffer-pmhub < "$TMP_SQL2"; then
    echo "  ✅ SQL 导入完成（使用 --force 忽略错误）。"
  else
    echo "  ⚠ SQL 导入遇到严重错误。请手动检查 $PROJECT_ROOT/sql/init.sql 并运行导入。"
  fi
  rm -f "$TMP_SQL" "$TMP_SQL2"
else
  echo "  ⚠ 未找到 SQL 文件: $PROJECT_ROOT/sql/init.sql"
fi

# 启动 Redis（并尽量避免 overcommit 警告）
echo "  启动 Redis..."
sudo sysctl -w vm.overcommit_memory=1 >/dev/null 2>&1 || true
sudo redis-server --daemonize yes || echo "  ⚠ 无法启动 Redis，请手动检查 redis-server 日志"

# [5/5] Maven 构建（默认不自动构建，避免因代码编译问题中断脚本）
echo "[5/5] Maven 构建（默认未运行）..."
echo "  为避免项目编译错误中断脚本，默认不在脚本内自动运行 Maven。若要在脚本内构建，请设置环境变量 RUN_MAVEN=true 并重新运行。"
if [ "${RUN_MAVEN}" = "true" ]; then
  # 切换到 Java 17（如果已安装），以兼容 Lombok 注解处理器
  if [ -d "/usr/lib/jvm/java-17-openjdk" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
    export PATH="$JAVA_HOME/bin:$PATH"
    echo "  使用 Java: $(java -version 2>&1 | head -n 1)"
  fi
  cd "$PROJECT_ROOT"
  if ! mvn package -DskipTests -q; then
    echo "  ⚠ Maven 构建失败。请手动运行 'mvn package' 以查看详细错误并修复。"
  else
    echo "  ✅ Maven 构建成功。"
  fi
fi

echo ""
echo "========================================"
echo "  ✅ (部分) 环境准备完毕！请按以下顺序启动服务："
echo "========================================"
echo ""
echo "  cd $PROJECT_ROOT"
echo ""
echo "  按顺序启动 (每个新开一个终端):"
echo "  1. mvn spring-boot:run -pl pmhub-eureka"
echo "  2. mvn spring-boot:run -pl pmhub-gateway"
echo "  3. mvn spring-boot:run -pl pmhub-auth"
echo "  4. mvn spring-boot:run -pl pmhub-modules/pmhub-system"
echo "  5. mvn spring-boot:run -pl pmhub-modules/pmhub-project"
echo "  6. mvn spring-boot:run -pl pmhub-modules/pmhub-workflow"
echo "  7. mvn spring-boot:run -pl pmhub-modules/pmhub-job"
echo "  8. mvn spring-boot:run -pl pmhub-monitor"
echo ""
echo "  📌 Gateway:  http://localhost:6880"
echo "  📌 Eureka:   http://localhost:8761"
echo "  📌 Monitor:  http://localhost:6888"
echo ""