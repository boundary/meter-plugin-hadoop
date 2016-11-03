# TrueSight Pulse Hadoop Plugin

This plugin grabs metrics from the Hadoop node where it is started and parses the data to be able to integrate into boundary. 

## Prerequisites

### Supported OS

|     OS    | Linux | Windows | SmartOS | OS X |
|:----------|:-----:|:-------:|:-------:|:----:|
| Supported |   v   |         |         |      |

- Hadoop version 2.7.0+

#### For Centos/RHEL/Ubuntu

- To install Hadoop on centos/RHEL [see instructions](http://tecadmin.net/setup-hadoop-2-4-single-node-cluster-on-linux/)
- To install Hadoop on ubuntu [see instructions](http://thepowerofdata.io/setting-up-a-apache-hadoop-2-7-single-node-on-ubuntu-14-04/)

#### TrueSight Pulse Meter versions v4.5 or later

- To install new meter go to Settings->Installation or [see instructons|https://help.boundary.com/hc/en-us/sections/200634331-Installation]. 
- To upgrade the meter to the latest version - [see instructons|https://help.boundary.com/hc/en-us/articles/201573102-Upgrading-the-Boundary-Meter].


### Plugin Setup

none

     
### Plugin Configuration Fields


|Field Name      |Description                                                             |
|:---------------|:-----------------------------------------------------------------------|
|Host            |The hadoop hostname                  |
|PollInterval    |How often (in milliseconds) to poll for metrics.                                       |

### Metrics Collected


|Metric Name                                    |Description                                                                |
|:-----------------------                       |:--------------------------------------------------------------------------|
|HADOOP_NAMENODE_FS_CAPACITY_REMAINING          |Remaining disk space left in bytes                                         |
