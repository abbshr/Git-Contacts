## Git Contacts

### 什么是 Git Contacts

GitContacts是采用Git来存储、共享通讯录的新的方式。适用于单一群体间（家庭、工作场合、同学圈）成员共享通讯录。

### 解决了什么问题

单一群体间共享通讯录，又难以做到权限控制。一般来说，用户对自己的名片拥有完全的权限，对他人的名片有读权限。根据KISS原则，只要每个人做到维护好自己的名片，那么整个群体间的通讯录就能良好运作。当一个人更改了自己的联系方式后，无需通知其他人。

目前实验室采用的名片服务器没有写权限的控制，用户误操作就容易修改他人名片或者加入他人名片。误操作发生后没有回滚的机制。

### 如何解决

Git Contacts在Git仓库的基础上进行封装，Git仓库仅做通讯录数据存储使用。用户刷新通讯录操作对应Git中的Pull。而对通讯录的修改操作（Merge）操作放入一个队列，如果用户操作的是自己的名片，则自动允许Merge，否则需要经过群体的管理员批准。
这些操作都需要在Git操作基础上进行RESTful的封装，以适合所有的客户端（iOS、Android、Web）。

用户的误操作可以通过管理员进行回滚（Revert）到之前的版本完成。

### 系统设计

Git-Contacts的系统由三部分组成，每部分负责任务不同，各部分独立为一个开发分支

- Gitdb
- Git-Contacts
- Web-Service

Gitdb 负责底层的数据存储，比如 Card 和 Contacts 的底层读写，封装了Git的常用操作。

Git-Contacts 负责上层的数据存储，比如用户管理、读写权限管理、Request 管理等操作。

Web-Service 负责 RESTful API 部分，将 payload 传至 Git-Contacts

### To-do

完成CardDAV[RFC6352](http://www.ietf.org/rfc/rfc6352.txt)中服务器端所有接口。
