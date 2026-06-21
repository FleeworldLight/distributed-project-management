#!/bin/bash
set -e

echo "========================================"
echo "  DPM — Codespace Environment Setup"
echo "========================================"

# 启动 MySQL (GitHub Codespace 内置)
if command -v mysql &> /dev/null; then
  echo "[1/5] MySQL 已就绪"
else
  echo "[1/5] 安装 MySQL..."
  sudo apt-get update -qq && sudo apt-get install -y -qq mysql-server
  sudo service mysql start
fi

# 创建数据库
echo "[2/5] 创建数据库 laigeoffer-pmhub..."
sudo mysql -e "CREATE DATABASE IF NOT EXISTS \`laigeoffer-pmhub\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null || true
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456'; FLUSH PRIVILEGES;" 2>/dev/null || true

# 导入 SQL
echo "[3/5] 导入表结构和初始数据..."
sudo mysql -u root -p123456 laigeoffer-pmhub < sql/init.sql 2>/dev/null || echo "  ⚠ SQL导入有误，请检查 sql/init.sql"

# 等待 MySQL 就绪
echo "[4/5] 等待 MySQL 就绪..."
sleep 2

# 编译项目
echo "[5/5] Maven 编译 (跳过测试)..."
cd "$(dirname "$0")/.."
mvn package -DskipTests -q

echo ""
echo "========================================"
echo "  ✅ 环境就绪！请按以下顺序启动服务："
echo "========================================"
echo ""
echo "  cd distributed-project-management"
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
