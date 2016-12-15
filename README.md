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
- To install Hadoop on multi node [see instructions](https://www.tutorialspoint.com/hadoop/hadoop_multi_node_cluster.htm)

#### TrueSight Pulse Meter versions v4.5 or later

- To install new meter go to Settings->Installation or [see instructons|https://help.boundary.com/hc/en-us/sections/200634331-Installation]. 
- To upgrade the meter to the latest version - [see instructons|https://help.boundary.com/hc/en-us/articles/201573102-Upgrading-the-Boundary-Meter].


### Plugin Setup

none

     
### Plugin Configuration Fields


|Field Name      |Description                                                             |
|:---------------|:-----------------------------------------------------------------------|
|Host            |The hadoop hostname                                                     |
|Type            |Type of hadoop node to monitor                                          |
|RM Port         |Resource manager hadoop port number                                     |
|DataNode Port   |DataNode hadoop port number                                             |
|NameNode Port   |NameNode hadoop port number                                             |
|PollInterval    |How often (in milliseconds) to poll for metrics. Default value for this is 1000 ms, we recommend not have smaller value                                                                                     |

### Metrics Collected


|Metric Name                                           |Description                                                                |
|:-----------------------                              |:--------------------------------------------------------------------------|
|HADOOP_NAMENODE_FS_CAPACITY_REMAINING                 |Remaining disk space left in bytes                                         |
|HADOOP_NAMENODE_FS_CORRUPTED_BLOCKS                   |Number of corrupt blocks                                                   |
|HADOOP_NAMENODE_FS_MISSINGED_BLOCKS                   |Number of missing blocks                                                   |
|HADOOP_NAMENODE_FS_BLOCKSED_TOTAL                     |Total number of blocks                                                     |
|HADOOP_NAMENODE_FS_FILES_TOTAL                        |Total number of files                                                      |
|HADOOP_NAMENODE_FS_BLOCKED_CAPACITY                   |Total Blocked Capacitys                                                    |
|HADOOP_NAMENODE_FS_UNDER_REPLICATED_BLOCKS            |Number of under replicated blocks                                          |
|HADOOP_NAMENODE_FS_CAPACITYED_USED                    |Disk usage in bytes                                                        |
|HADOOP_NAMENODE_FS_TOTAL_LOAD                         |Total load on the file system                                              |
|HADOOP_NAMENODE_FSSTATE_VOLUME_FAILURES_TOTAL         |Total volume failures                                                      |
|HADOOP_NAMENODE_FSSTATE_NUMBER_OF_LIVE_DATA_NODES     |Total number of live data nodes                                            |
|HADOOP_NAMENODE_FSSTATE_NUMBER_OF_DEAD_DATA_NODES     |Total number of dead data nodes                                            |
|HADOOP_NAMENODE_FSSTATE_NUMBER_OF_STALE_DATA_NODES    |Number of stale data nodes                                                 |
|HADOOP_MAP_REDUCED_PROCESS_CPU_TIME                   |Prcesss cpu time                                                           |
|HADOOP_MAP_REDUCED_PROCESS_CPU_LOAD                   |Prcesss cpu load                                                           |
|HADOOP_MAP_REDUCED_SYSTEM_CPU_LOAD                    |System cpu load                                                            |
|HADOOP_MAP_REDUCED_AVAILABLE_PROCESSORS               |Number of processors available                                             |
|HADOOP_MAP_REDUCED_TOTAL_SWAP_SPACE_SIZE              |Total swap space size                                                      |
|HADOOP_MAP_REDUCED_FREE_SWAP_SPACE_SIZE               |Total swap space free                                                      |
|HADOOP_MAP_REDUCED_FREE_PHYSICAL_MEMORY_SIZE          |Physical memory free size                                                  |
|HADOOP_MAP_REDUCED_TOTAL_PHYSICAL_MEMORY_SIZE         |Total Physical memory size                                                 |
|HADOOP_YARN_APPLICATION_RUNNING                       |The number of running apps                                                 |
|HADOOP_YARN_APPLICATION_FAILED                        |The number of failed apps                                                  |
|HADOOP_YARN_APPLICATION_KILLED                        |The number of killed apps                                                  |
|HADOOP_YARN_APPLICATION_PENDING                       |The number of pending apps                                                 |
|HADOOP_YARN_AVAILABLE_MEMORY                          |The amount of available memory                                             |
|HADOOP_YARN_AVAILABLE_VCORES                          |The number of available virtual cores                                      |
|HADOOP_YARN_NUMMBER_OF_UNHEALTHY_NODES                |The number of unhealthy nodes                                              |
|HADOOP_YARN_NUMMBER_OF_ACTIVE_NODES                   |The number of active nodes                                                 |
|HADOOP_YARN_NUMMBER_OF_LOST_NODES                     |The number of lost nodes                                                   |
|HADOOP_YARN_USED_MEMORY                               |Total used memory                                                          | 
|HADOOP_YARN_NUMBER_OF_CONTAINERS                      |Number of containers                                                       |   
|HADOOP_DATANODE_HEAP_MEMORY_USED                      |Heap memory used                                                           | 
|HADOOP_DATANODE_HEAP_MEMORY_MAX                       |Heap memory max used                                                       |
|HADOOP_DATANODE_GC_COUNT                              |GC count                                                                   |
|HADOOP_DATANODE_GC_TIME_MILLIS                        |GC time milliseconds                                                       |    
|HADOOP_DATANODE_GC_NUMBER_OF_WARN_THREADSHOLD_EXCEEDED|GC of warn threadshold exceeded                                            |
|HADOOP_DATANODE_GC_NUMBER_OF_INFO_THREADSHOLD_EXCEEDED|GC of info threadshold exceeded                                            |
|HADOOP_DATANODE_GC_TOTAL_EXTRA_SLEEP_TIME             |GC extra sleep time                                                        |
|HADOOP_DATANODE_BLOCKS_READ                           |Blocks read                                                                |
|HADOOP_DATANODE_BLOCKS_WRITTEN                        |Blocks written                                                             |
|HADOOP_DATANODE_VOLUME_FAILURES                       |Number of failed  volumes                                                  |
|HADOOP_DATANODE_NUMBER_OF_FAILED_STORAGE_VOLUMES      |Number of failed storage volumes                                           |
|HADOOP_DATANODE_REMAINING_CAPACITY                    |Remaining disk space                                                       |

