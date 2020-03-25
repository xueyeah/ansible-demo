## 使用手册

#### 一、Ansible简介

​	“Ansible is Simple IT Automation”——简单的自动化IT工具

 	Ansible跟其他IT自动化技术的区别在于其关注点并非配置管理、应用部署或IT流程工作流，而是提供一个统一的界面来协调所有的IT自动化功能，因此Ansible的系统更加易用，部署更快。

​	 Ansible可以让用户避免编写脚本或代码来管理应用，同时还能搭建工作流实现IT任务的自动化执行。IT自动化可以降低技术门槛及对传统IT的依赖，从而加快项目的交付速度。

#### 二、Ansible安装

##### 	本文实验环境 ：

​			Linux centos6.5  ，Python2.6.6 

##### 	Ansible 通过yum 安装执行如下命令:

```bash
	yum install ansible -y
```

 ps:当然也可通过源码下载tar包安装，也可通过pip安装。

#### 三、ansible-mms文件目录说明

```bash
ansible-mms  			#主文件目录
	file				#在ansible执行时可加载里面的文件
		auth
		baserpm
		jdk.tar.gz      #jdk jar包，在各个主机创建java环境时，需要往其他机器复制jdk包。
		...
	group_vars			#全局配置文件目录
		all				#在ansible执行任务时，加载all文件中配置信息，以key：value形式
	roles				#角色目录
		common			#common 角色，在mms_basic.yml中执行的角色配置为common
		...
	ansible.cfg			#ansible 配置文件
	hosts				#主机配置信息文件
	mms_basic.yml		#ansible 执行任务的脚本
	
```



#### 四、脚本执行命令：

```bash
ansible-playbook -v mms_basic.yml
```

ps:进入 ansible-mms 目录中，执行上述命令，即可安装mms基础包

#### 五、关键文件说明

##### 1.ansible.cfg

​	ansible.cfg 文件为主机配置信息文件，

```bash
[defaults]
inventory = hosts 		#指定配置的主机文件为hosts文件
host_key_checking = false #ssh首次连接主机时候关闭提示输入信息
```

##### 2.hosts

​	hosts文件主要是配置主机信息

```bash
[mms]
ct-mms-1  ansible_host=192.168.208.101 ansible_port=22 ansible_user=root ansible_ssh_pass=123456
ct-mms-2  ansible_host=192.168.208.102 ansible_port=22 ansible_user=root ansible_ssh_pass=123456
ct-mms-3  ansible_host=192.168.208.103 ansible_port=22 ansible_user=root ansible_ssh_pass=123456
```

有三台目标主机名分别为ct-mms-1，ct-mms-2，ct-mms-3

ansible_host 为对应主机名的IP地址

ansible_port 为对应主机名ssh端口

ansible_user 为对应主机名ssh用户

ansible_ssh_pass 为对应主机名ssh密码

添加或者删除目标主机，按格式增加一行或者删减一行即可

##### 3.mms_basic.yml

```bash
---
- hosts: mms							#指定hosts文件中的【mms】
  become: true	
  roles:
    - role: common						#指定执行common角色中的任务
      vars:								#为角色common 设置变量
        common_action: roles/common/tasks/instantiate #执行common时，默认找到roles/common/tasks 目录下的main.yaml,main.yaml通过common_action变量找到对应任务的yaml
#        common_action: roles/common/tasks/base_rpm  
```

注：instantiate.yaml 中通过include 多个yaml文件来执行多个任务，name为任务说明。

##### 4.all

​	在文件./ansible-mms/group_vars/all 中，添加nxuser 用户的密码配置信息如下：“nxuser”为默认设置的nxuser用户密码，可自行更改。

```bash
---
# Variables listed here are applicable to all host groups

user_password: nxuser
```

注：本例子中user.yaml 调用该变量（ {{user_password}} ）

```bash
- name: create nxuser user
  user: name=nxuser group=nxgroup uid=501 password={{ user_password | password_hash('sha512') }}
  become: true
  become_user: root
  become_method: sudo
```

更多介绍请看  https://docs.ansible.com/ansible/2.6/user_guide/