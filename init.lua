-- Copyright 2015 BMC Software, Inc.
-- --
-- -- Licensed under the Apache License, Version 2.0 (the "License");
-- -- you may not use this file except in compliance with the License.
-- -- You may obtain a copy of the License at
-- --
-- --    http://www.apache.org/licenses/LICENSE-2.0
-- --
-- -- Unless required by applicable law or agreed to in writing, software
-- -- distributed under the License is distributed on an "AS IS" BASIS,
-- -- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- -- See the License for the specific language governing permissions and
-- -- limitations under the License.

--Framework imports.
local framework = require('framework')

local Plugin = framework.Plugin
local WebRequestDataSource = framework.WebRequestDataSource
local DataSourcePoller = framework.DataSourcePoller
local PollerCollection = framework.PollerCollection
local isHttpSuccess = framework.util.isHttpSuccess
local ipack = framework.util.ipack
local parseJson = framework.util.parseJson

--Getting the parameters from params.json.
local params = framework.params

local NAMENODE_KEY = 'NAMENODE_MAP_KEY'
local DATANODE_KEY = 'DATANODE_MAP_KEY'
local YARNMAP_KEY = 'YARNMAP_MAP_KEY'
--Default hadoop ports
local DATANODE_PORT='50075'
local NAMENODE_PORT='50070'
local YARN_RM_PORT='8088'
local HADOOP_JMX_PATH='/jmx'
local BEANS_CONSTANT='beans'
local FEATCH_DATANODE_JVMMETRICS='Hadoop:service=DataNode,name=JvmMetrics'
local FEATCH_DATANODE_ACTIVITY='DataNodeActivity'
local FEATCH_DATANODE_STORAGE='org.apache.hadoop.hdfs.server.datanode.fsdataset.impl.FsDatasetImpl'
local FEATCH_NAMENODE_FSSYSTEM_STATE='Hadoop:service=NameNode,name=FSNamesystemState'
local FEATCH_NAMENODE_FSSYSTEM='Hadoop:service=NameNode,name=FSNamesystem'
local FEATCH_CPU_MAPREDUCED='java.lang:type=OperatingSystem'
local FEATCH_YARN_QUEUED_MATRICS='Hadoop:service=ResourceManager,name=QueueMetrics,q0=root'
local FEATCH_YARN_CLUSTER_METRICS ='Hadoop:service=ResourceManager,name=ClusterMetrics'
local FEATCH_YARN_LIVE_NODE_RM='Hadoop:service=ResourceManager,name=RMNMInfo'
local MB_TO_BYTES = 1048576

--Split string by comma
function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end

local function createOptions(item,port)

  local options = {}
  options.host = item.host
  options.port = port
  options.wait_for_end = true

  return options
end

local function createNameNodeDataSource(item,port)

  local options = createOptions(item,port)

  options.path = HADOOP_JMX_PATH
  options.meta = {NAMENODE_KEY, item}

  return WebRequestDataSource:new(options)
end

local function createDataNodeDataSource(item,port)

  local options = createOptions(item,port)

  options.path = HADOOP_JMX_PATH
  options.meta = {DATANODE_KEY, item}

  return WebRequestDataSource:new(options)
end

local function createYarnAndMapReducedDataSource(item,port)
  local options = createOptions(item,port)

  options.path = HADOOP_JMX_PATH
  options.meta = {YARNMAP_KEY, item}

  return WebRequestDataSource:new(options)
end

local function createPollers(params)
  local pollers = PollerCollection:new()

  for _, item in pairs(params.items) do
    local dataNode = createDataNodeDataSource(item,DATANODE_PORT)
    local dataNodePoller = DataSourcePoller:new(item.pollInterval, dataNode)
    pollers:add(dataNodePoller)

    local nameNode = createNameNodeDataSource(item,NAMENODE_PORT)
    local nameNodePoller = DataSourcePoller:new(item.pollInterval, nameNode)
    pollers:add(nameNodePoller)

    local yarnAndMapReduced = createYarnAndMapReducedDataSource(item,YARN_RM_PORT)
    local yarnAndMapReducedPoller = DataSourcePoller:new(item.pollInterval, yarnAndMapReduced)
    pollers:add(yarnAndMapReducedPoller)
  end

  return pollers
end

local function nameNodeDetailsExtractor (data, item)
  local result = {}
  local metric = function (...) ipack(result, ...) end
  local nameNode = data[BEANS_CONSTANT]
  local source = item.host
  for _, item in pairs(nameNode) do
     if FEATCH_NAMENODE_FSSYSTEM == item.name then
      metric('HADOOP_NAMENODE_FS_CAPACITY_REMAINING', item.CapacityRemaining, nil, source)
      metric('HADOOP_NAMENODE_FS_CORRUPTED_BLOCKS', item.CorruptBlocks, nil, source)
      metric('HADOOP_NAMENODE_FS_MISSINGED_BLOCKS', item.MissingBlocks, nil, source)
      metric('HADOOP_NAMENODE_FS_BLOCKSED_TOTAL', item.BlocksTotal, nil, source)
      metric('HADOOP_NAMENODE_FS_FILES_TOTAL', item.FilesTotal, nil, source)
      metric('HADOOP_NAMENODE_FS_BLOCKED_CAPACITY', item.BlockCapacity, nil, source)
      metric('HADOOP_NAMENODE_FS_UNDER_REPLICATED_BLOCKS', item.UnderReplicatedBlocks, nil, source)
      metric('HADOOP_NAMENODE_FS_CAPACITYED_USED', item.CapacityUsed, nil, source)
      metric('HADOOP_NAMENODE_FS_TOTAL_LOAD', item.TotalLoad, nil, source)
     end
     if FEATCH_NAMENODE_FSSYSTEM_STATE == item.name then
      metric('HADOOP_NAMENODE_FSSTATE_VOLUME_FAILURES_TOTAL', item.VolumeFailuresTotal, nil, source)
      metric('HADOOP_NAMENODE_FSSTATE_NUMBER_OF_LIVE_DATA_NODES', item.NumLiveDataNodes, nil, source)
      metric('HADOOP_NAMENODE_FSSTATE_NUMBER_OF_DEAD_DATA_NODES', item.NumDeadDataNodes, nil, source)
      metric('HADOOP_NAMENODE_FSSTATE_NUMBER_OF_STALE_DATA_NODES', item.NumStaleDataNodes, nil, source)
     end
  end

  return result
end

local function dataNodeDetailsExtractor (data, item)
  local result = {}
  local metric = function (...) ipack(result, ...) end
  local dataNode = data[BEANS_CONSTANT]
  local source = item.host
  for _, item in pairs(dataNode) do
     if FEATCH_DATANODE_JVMMETRICS == item.name then
      metric('HADOOP_DATANODE_HEAP_MEMORY_USED', item.MemHeapUsedM * MB_TO_BYTES, nil, source)
      metric('HADOOP_DATANODE_HEAP_MEMORY_MAX', item.MemHeapMaxM * MB_TO_BYTES, nil, source)
      metric('HADOOP_DATANODE_GC_COUNT', item.GcCount, nil, source)
      metric('HADOOP_DATANODE_GC_TIME_MILLIS', item.GcTimeMillis, nil, source)
      metric('HADOOP_DATANODE_GC_NUMBER_OF_WARN_THREADSHOLD_EXCEEDED', item.GcNumWarnThresholdExceeded, nil, source)
      metric('HADOOP_DATANODE_GC_NUMBER_OF_INFO_THREADSHOLD_EXCEEDED', item.GcNumInfoThresholdExceeded, nil, source)
      metric('HADOOP_DATANODE_GC_TOTAL_EXTRA_SLEEP_TIME', item.GcTotalExtraSleepTime, nil, source)
     end
     local activityArray = (item.modelerType):split("-")
     if FEATCH_DATANODE_ACTIVITY == activityArray[1] then
     metric('HADOOP_DATANODE_BLOCKS_READ', item.BlocksRead, nil, source)
     metric('HADOOP_DATANODE_BLOCKS_WRITTEN', item.BlocksWritten, nil, source)
     metric('HADOOP_DATANODE_VOLUME_FAILURES', item.VolumeFailures, nil, source)
     end
     if FEATCH_DATANODE_STORAGE == item.modelerType then
     metric('HADOOP_DATANODE_NUMBER_OF_FAILED_STORAGE_VOLUMES', item.NumFailedVolumes, nil, source)
     metric('HADOOP_DATANODE_REMAINING_CAPACITY', item.Remaining, nil, source)
     end
  end
  return result
end

local function yarnMapReducedDetailsExtractor (data, item)
  local result = {}
  local metric = function (...) ipack(result, ...) end
  local yarnAndMapReducedNode = data[BEANS_CONSTANT]
  local source = item.host
  for _, item in pairs(yarnAndMapReducedNode) do
    if FEATCH_CPU_MAPREDUCED == item.name then
      metric('HADOOP_MAP_REDUCED_PROCESS_CPU_TIME', item.ProcessCpuTime, nil, source)
      metric('HADOOP_MAP_REDUCED_PROCESS_CPU_LOAD', item.ProcessCpuLoad, nil, source)
      metric('HADOOP_MAP_REDUCED_SYSTEM_CPU_LOAD', item.SystemCpuLoad, nil, source)
      metric('HADOOP_MAP_REDUCED_AVAILABLE_PROCESSORS', item.AvailableProcessors, nil, source)
      metric('HADOOP_MAP_REDUCED_TOTAL_SWAP_SPACE_SIZE', item.TotalSwapSpaceSize, nil, source)
      metric('HADOOP_MAP_REDUCED_FREE_SWAP_SPACE_SIZE', item.FreeSwapSpaceSize, nil, source)
      metric('HADOOP_MAP_REDUCED_FREE_PHYSICAL_MEMORY_SIZE', item.FreePhysicalMemorySize, nil, source)
      metric('HADOOP_MAP_REDUCED_TOTAL_PHYSICAL_MEMORY_SIZE', item.TotalPhysicalMemorySize, nil, source)
    end
    if FEATCH_YARN_QUEUED_MATRICS == item.name then
       metric('HADOOP_YARN_APPLICATION_RUNNING', item.AppsRunning, nil, source)
       metric('HADOOP_YARN_APPLICATION_FAILED', item.AppsFailed, nil, source)
       metric('HADOOP_YARN_APPLICATION_KILLED', item.AppsKilled, nil, source)
       metric('HADOOP_YARN_APPLICATION_PENDING', item.AppsPending, nil, source)
       metric('HADOOP_YARN_AVAILABLE_MEMORY', item.AvailableMB * MB_TO_BYTES, nil, source)
       metric('HADOOP_YARN_AVAILABLE_VCORES', item.AvailableVCores, nil, source)
    end
    if FEATCH_YARN_CLUSTER_METRICS == item.name then
       metric('HADOOP_YARN_NUMMBER_OF_UNHEALTHY_NODES', item.NumUnhealthyNMs, nil, source)
       metric('HADOOP_YARN_NUMMBER_OF_ACTIVE_NODES', item.NumActiveNMs, nil, source)
       metric('HADOOP_YARN_NUMMBER_OF_LOST_NODES', item.NumLostNMs, nil, source)
    end
    if FEATCH_YARN_LIVE_NODE_RM == item.name then
     --metric('HADOOP_YARN_USED_MEMORY', item.NumLostNMs, nil, source)
    end
  end
  return result
end

local extractors_map = {}
extractors_map[NAMENODE_KEY] = nameNodeDetailsExtractor
extractors_map[DATANODE_KEY] = dataNodeDetailsExtractor
extractors_map[YARNMAP_KEY] = yarnMapReducedDetailsExtractor


local pollers = createPollers(params)
local plugin = Plugin:new(params, pollers)

--Response returned for each of the pollers.
function plugin:onParseValues(data, extra)
  local success, parsed = parseJson(data)

  if not isHttpSuccess(extra.status_code) then
    self:emitEvent('error', ('Http request returned status code %s instead of OK. Please verify configuration.'):format(extra.status_code))
    return
  end

  local success, parsed = parseJson(data)
  if not success then
    self:emitEvent('error', 'Cannot parse metrics. Please verify configuration.')
    return
  end

  local key, item = unpack(extra.info)
  local extractor = extractors_map[key]
  return extractor(parsed, item)

end

plugin:run()

