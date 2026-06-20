# DPM 分布式项目管理系统

基于 Spring Cloud 微服务架构的分布式项目管理系统，支持项目管理、任务看板、工作流审批等核心功能。

## 技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Spring Boot | 2.7.18 | 基础框架 |
| Spring Cloud | 2021.0.8 | 微服务框架 |
| Eureka | 2021.0.8 | 服务注册中心 |
| Gateway | 3.1.8 | API网关 |
| Flowable | 6.7.2 | 工作流引擎 |
| Redis | Latest | 分布式缓存 |
| MySQL | 8.0+ | 持久化存储 |
| Vue 2 | 2.6.12 | 前端框架 |
| Element UI | 2.15.10 | 前端UI组件库 |
| ECharts | Latest | 数据可视化 |

## 模块结构

```
distributed-project-management
├── pmhub-eureka           -- 注册中心 (8761)
├── pmhub-gateway          -- API网关 (6880)
├── pmhub-auth             -- 认证中心 (6800)
├── pmhub-base
│   ├── pmhub-base-core    -- 核心工具
│   ├── pmhub-base-security-- 安全模块
│   └── pmhub-base-swagger -- 接口文档
├── pmhub-api
│   ├── pmhub-api-system   -- 系统Feign接口
│   └── pmhub-api-workflow -- 工作流Feign接口
├── pmhub-modules
│   ├── pmhub-system       -- 系统管理 (6801)
│   ├── pmhub-project      -- 项目管理 (6806)
│   ├── pmhub-workflow     -- 流程引擎 (6808)
│   └── pmhub-job          -- 定时任务 (6803)
├── pmhub-monitor          -- 监控中心 (6888)
├── pmhub-ui               -- Vue2 前端
└── docker                 -- Docker部署配置
```

## 快速启动

### 环境要求

- JDK 1.8+
- MySQL 8.0+
- Redis
- Maven 3.4+

### 启动步骤

**1. 创建数据库并导入脚本**

```sql
CREATE DATABASE IF NOT EXISTS `laigeoffer-pmhub` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

然后执行 `sql/` 目录下的 SQL 脚本初始化表结构和数据。

**2. 按顺序启动微服务**

```
pmhub-eureka (8761) → pmhub-gateway (6880) → pmhub-auth (6800)
→ pmhub-system (6801) → pmhub-project (6806) → pmhub-workflow (6808)
→ pmhub-job (6803) → pmhub-monitor (6888)
```

各模块 Application 类可直接在 IntelliJ IDEA 中右键运行。

**3. 启动前端**

```bash
cd pmhub-ui
npm install
npm run dev
```

访问 http://localhost:9527

## 演示功能

- 用户登录/注册 + JWT 令牌认证
- 项目管理：创建/编辑/归档/成员管理
- 任务看板：拖拽式任务卡片，支持状态流转
- 工作流审批：BPMN 流程定义 + 节点审批
- 数据看板：ECharts 可视化统计
- 系统管理：用户/角色/权限/菜单配置
