# TrueSight Pulse Hadoop Plugin

This plugin grabs metrics from the Hadoop node where it is started and parses the data to be able to integrate into boundary. 

## Prerequisites

### Supported OS

|     OS    | Linux | Windows | SmartOS | OS X |
|:----------|:-----:|:-------:|:-------:|:----:|
| Supported |   v   |         |         |      |

- Hadoop version 2.7.0+

#### For Centos/RHEL/Ubuntu

- To install OpenStack on centos v7.x/rhel v7.x [see instructions](https://www.rdoproject.org/install/quickstart/)
- To install OpenStack on ubuntu v14.04(trusty) [see instructions](http://docs.openstack.org/developer/devstack/guides/single-machine.html)

#### TrueSight Pulse Meter versions v4.0 or later

- To install new meter go to Settings->Installation or [see instructons|https://help.boundary.com/hc/en-us/sections/200634331-Installation]. 
- To upgrade the meter to the latest version - [see instructons|https://help.boundary.com/hc/en-us/articles/201573102-Upgrading-the-Boundary-Meter].


### Plugin Setup

#### For CentOS 7.x & RHEL 7.x and Ubuntu v14.04(trusty)
To get ceilometer configuration such as host, port and more, goto below file.
```
Default path for ceilometer configuration file is "/etc/ceilometer/ceilometer.conf"
```

     
### Plugin Configuration Fields


|Field Name      |Description                                                             |
|:---------------|:-----------------------------------------------------------------------|
|Host            |The hadoop hostname                  |
|PollInterval    |How often (in milliseconds) to poll for metrics.                                       |

### Metrics Collected


|Metric Name                                    |Description                                                                |
|:-----------------------                       |:--------------------------------------------------------------------------|
|HADOOP_NAMENODE_FS_CAPACITY_REMAINING          |Remaining disk space left in bytes                                         |
