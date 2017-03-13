"""DT REST API Library"""

import requests
import sys
import json
import re
import unicodedata
from robot.api import logger
# sys.path.append("..")
# sys.path.append("/home/pradeep/workspace/QA/framework/lib/")
# import helpers

class DTREST(object):
    """
    Test library for testing DT REST APIs
    """
    def __init__(self):
        self._statuscode = 0
        self.rjson = ''
        self.rheaders = ''

    def get_api(self, uri, api, injson=False):
        """
        Get specified API url, accepts baseurl, api
        :param uri: Base URL
        :param api: REST API to be used
        :param injson: if output should be returned as json
        :return: self.json OR apiresponse.content
        """
        print "Getting: ", uri+'/'+api
        apiresponse = requests.get(uri+'/'+api)

        self.rheaders = apiresponse.headers
        if injson:
            self.rjson = apiresponse.json()
        self._statuscode = apiresponse.status_code
        if self._statuscode != 200:
            raise AssertionError("Invalid status code returned: ", self._statuscode)
        logger.debug(self.rheaders)
        logger.debug(self.rheaders['content-type'])
        #if self.rheaders['content-type'] != 'application/json':
        #    raise AssertionError("Invalid content-type returned: ", self.rheaders['content-type'])
        if injson:
            return self.rjson
        else:
            return apiresponse.content

    def post_AppPackage(self, uri, filename, pathtofile, injson=False, api='appPackages?filename='):
        """
        Post files on endpoint after reading the payload file.
        :param uri: Base URL
        :param filename: Name of the file
        :param pathtofile: Path to file
        :param injson: if output should be returned as json
        :param api: API to be called
        :return: apiresponse
        """
        filetopost = open(pathtofile + '/' + filename, 'rb')
        apiendpoint = api + filename
        logger.debug(apiendpoint)
        apiresponse = self.post_api(uri, apiendpoint, payload=filetopost, injson=injson)
        logger.debug(apiresponse)
        return apiresponse
        
    def post_api(self, uri, api, payload, injson=False):
        """
        Post specified payload on API url, accpets baseurl, api, payload
        :param uri: Base URL
        :param api: API to be called
        :param payload: payload to be sent
        :param injson: if output should be returned as json
        :return: self.json OR apiresponse.content
        """
        #by-pradeep_temporary
        headers = {'Content-Type': 'application/json'}
        apiresponse = requests.post(uri+'/'+api, data=payload, headers=headers)
        ###########
        #apiresponse = requests.post(uri+'/'+api, data=payload)
        self.rheaders = apiresponse.headers
        self.rjson = apiresponse.json()
        self._statuscode = apiresponse.status_code
        if self._statuscode != 200:
            raise AssertionError("Invalid status code returned: ", self._statuscode)
        logger.debug(self.rheaders)
        logger.debug(self.rheaders['content-type'])
        if self.rheaders['content-type'] != 'application/json':
            raise AssertionError("Invalid content-type returned: ", self.rheaders['content-type'])   
        if injson:
            return self.rjson
        else:
            return apiresponse.content

    def delete_api(self, uri, api, injson=False):
        """
        Perform specified Delete request, accepts baseurl, api
        :param uri: Base URL
        :param api: REST API to be used
        :param injson: if output should be returned as json
        :return: self.json OR apiresponse.content
        """
        apiresponse = requests.delete(uri+'/'+api)
        self.rheaders = apiresponse.headers
        self.rjson = apiresponse.json()
        self._statuscode = apiresponse.status_code
        if self._statuscode != 200:
            raise AssertionError("Invalid status code returned: ", self._statuscode)
        logger.debug(self.rheaders)
        logger.debug(self.rheaders['content-type'])
        if self.rheaders['content-type'] != 'application/json':
            raise AssertionError("Invalid content-type returned: ", self.rheaders['content-type'])
        if injson:
            return self.rjson
        else:
            return apiresponse.content

    def ListAppByName(self, uri, appname, digforids=False, healthparams={}):
        """
        Lists applications by name
        :param uri: Base URL
        :param appname: Name of the App
        :param digforids: True/False
        :param healthparams: Health parameters
        :return: None
        """
        self.get_api(uri, 'applications?states=RUNNING', injson=True)
        print self.rjson
        appstate = False
        print "Checking for Application, by name:" + appname
        for i in self.rjson['apps']:
            if i['name'] == appname:
                print "Application Name: " + i['name']
                print "Application ID: " + i['id']
                print "Application User :" + i['user']
                if digforids is True:
                    self.ListAppStateByID(uri, i['id'], healthparams)
                    appstate = True
        if appstate is False:
            raise AssertionError("App State %s application %s is not running", appstate, appname)

    def CheckAppHealthStats(self, healthparams):
        """
        Check Application health,for a  few params
        :param healthparams: Health parameters
        :return: None
        """
        print "printing self.rjson"
        print self.rjson["stats"]
        appname = unicodedata.normalize('NFKD', self.rjson['name']).encode('ascii', 'ignore')
        print "incheckhealth: " + appname + " type:"
        appparams = healthparams[appname]
        print "App Params"
        print appparams
        appparamkeys = appparams.keys()
        print "App Params Keys"
        print appparamkeys
        for healthparam in appparamkeys:
            currentparamvalue = helpers.ConUniToInt(self.rjson["stats"][healthparam])
            print "health param: " + healthparam + ", Value: %d" \
                % currentparamvalue
            appparamtestkeys = appparams[healthparam].keys()
            for AppParamTestKey in appparamtestkeys:
                if AppParamTestKey == 'MT':
                    print "Testing " + healthparam + " for More Than ie: " \
                        + AppParamTestKey + " specified: " \
                        + str(appparams[healthparam]['MT']) + " actual: " + \
                        str(currentparamvalue)
                    try:
                        assert helpers.CheckIfMT(currentparamvalue, appparams[healthparam]['MT'])
                    except AssertionError, e:
                        message = "HealthParam " + healthparam + " is at: "
                        message = message + str(currentparamvalue) + \
                            " which is less than: " +\
                            str(appparams[healthparam]['MT'])
                        e.args = (message,)
                        raise
                elif AppParamTestKey == 'LT':
                    print "Testing " + healthparam + " for Less Than ie: "\
                     + AppParamTestKey + " specified: " + \
                     str(appparams[healthparam]['LT']) + " actual: " +\
                     str(currentparamvalue)
                try:
                    assert helpers.CheckIfLT(currentparamvalue,\
                    appparams[healthparam]['LT'])
                except AssertionError, e:
                    message = "HealthParam " + healthparam + " is at: "
                    message = message + str(currentparamvalue) +\
                        " which is more than: " + str(appparams[healthparam]['LT'])
                    e.args = (message,)
                    raise

    def getApplicationStats(self, uri, appid):
        """
        Accepts URI, application ID, returns application State.
        :param uri: Base URL
        :param appid: App ID
        :return: appstats
        """
        appstats, http_headers = self.get_api(uri, 'applications/'+appid)
        print http_headers
        print appstats
        return appstats

    def getAppPackages(self, uri):
        """
        Accepts URI, returns list of application packages. Works in Un-Authenticated Gateway
        :param uri: Base URL
        :return: appPackages
        """
        appPackages = self.get_api(uri, 'appPackages')
        return appPackages

    def importAppPackages(self, uri):
        """
        Accepts URI, imports application packages. Works in Un-Authenticated Gateway
        :param uri: Base URL
        :return: appPackages
        """
        appPackages = self.get_api(uri, 'appPackages/import', injson=True)
        logger.debug(appPackages)
        fileslist = []
        filesdict = {'files': fileslist}
        for appPackage in appPackages['appPackages']:
            logger.debug(appPackage)
            fileslist.append(appPackage['file'])
            logger.debug(fileslist)
        logger.debug(filesdict)
        self.post_api(uri, 'appPackages/import', payload=json.dumps(filesdict), injson=True)
        return appPackages

    def ListAppStateByID(self, uri, appid, healthparams):
        """
        Lists application's stats by id
        :param uri: Base URL
        :param appid: App ID
        :param healthparams: Health Parameters
        :return: None
        """
        self.get_api(uri, 'applications/'+appid)
        print "sending for checkup"
        self.CheckAppHealthStats(healthparams)

    def getAppsByState(self, uri, state=""):
        """
        Provided the base URL, it returns list of App IDs for apps which satisfy the 'state' criteria.
        If 'state' is not specified, returns all App IDs.
        :param uri: Base URL
        :param state: RUNNING, KILLED etc.
        :return: app_ids
        """
        api = 'applications' if state == "" else 'applications?states='+state
        self.get_api(uri, api, injson=True)
        if len(self.rjson["apps"]) == 0:
            raise AssertionError("No apps found with state="+state+"\n"+"JSON:"+"\n"+str(self.rjson))
        app_ids = [self.rjson["apps"][i]["id"] for i in range(0, len(self.rjson["apps"]))]
        return app_ids

    def getContainersForApp(self, uri, appId, state=""):
        """
        Provided the base URL & App ID, it returns list of all containers which satisfy the 'state' criteria.
        If 'state' is not specified, returns all Container IDs.
        :param uri: Base URL
        :param appId: App ID
        :param state: RUNNING, KILLED etc.
        :return: container_ids
        """
        print "State: <"+state+">"
        api = "applications/" + appId + "/physicalPlan/containers"
        self.get_api(uri, api, injson=True)
        if len(self.rjson["containers"]) == 0:
            raise AssertionError("No Containers found!"+"\n"+"JSON:"+"\n"+str(self.rjson))
        container_ids = []
        for i in range(0, len(self.rjson["containers"])):
            if state == "" or self.rjson["containers"][i]["state"] in state:
                container_ids.append(self.rjson["containers"][i]["id"])
        return container_ids

    def getContainerState(self, uri, appId, containerId):
        """
        Provided the base URL, App ID & container ID, it returns the state of the container.
        :param uri: Base URL
        :param appId: App ID
        :param containerId: Container ID
        :return: state
        """
        api = "applications/" + appId + "/physicalPlan/containers"
        self.get_api(uri, api, injson=True)
        if len(self.rjson["containers"]) == 0:
            raise AssertionError("No Containers found!"+"\n"+"JSON:"+"\n"+str(self.rjson))
        for i in range(0, len(self.rjson["containers"])):
            if self.rjson["containers"][i]["id"] in containerId:
                return self.rjson["containers"][i]["state"]
        return None

    def getContainerIdFromOperatorName(self, uri, appId, opName):
        """
        Provided the App ID & operator name, it returns the container ID for that operator.
        :param uri: Base URL
        :param appId: App ID
        :param opName: Operator Name
        :return: container_id
        """
        api = "applications/" + appId + "/physicalPlan/operators"
        self.get_api(uri, api, injson=True)
        if len(self.rjson["operators"]) == 0:
            raise AssertionError("No operators found!"+"\n"+"JSON:"+"\n"+str(self.rjson))
        for i in range(0, len(self.rjson["operators"])):
            if self.rjson["operators"][i]["name"] == opName:
                return self.rjson["operators"][i]["container"]
        print "WARN: Operator with name:", opName, "not found!!"
        return None

    def getContainerIdsFromOperatorName(self, uri, appId, opName):
        """
        Provided the App ID & operator name, it returns ALL the container IDs for that operator.
        Useful in case of PARALLEL partitions
        :param uri: Base URL
        :param appId: App ID
        :param opName: Operator Name
        :return: container_id
        """
        api = "applications/" + appId + "/physicalPlan/operators"
        self.get_api(uri, api, injson=True)
        if len(self.rjson["operators"]) == 0:
            raise AssertionError("No operators found!"+"\n"+"JSON:"+"\n"+str(self.rjson))
        cids = []
        for i in range(0, len(self.rjson["operators"])):
            if self.rjson["operators"][i]["name"] == opName:
                cids.append(self.rjson["operators"][i]["container"])
        if len(cids) == 0:
            raise AssertionError("Operator with name:", opName, "not found!!")
        return cids

    def getOperatorIdFromOperatorName(self, uri, appId, opName):
        """
        Provided the App ID & operator name, it returns the container ID for that operator.
        :param uri: Base URL
        :param appId: App ID
        :param opName: Operator Name
        :return: container_id
        """
        api = "applications/" + appId + "/physicalPlan/operators"
        self.get_api(uri, api, injson=True)
        if len(self.rjson["operators"]) == 0:
            raise AssertionError("No operators found!"+"\n"+"JSON:"+"\n"+str(self.rjson))
        for i in range(0, len(self.rjson["operators"])):
            if self.rjson["operators"][i]["name"] == opName:
                return self.rjson["operators"][i]["id"]
        print "WARN: Operator with name:", opName, "not found!!"
        return None

    def getOperatorsForApp(self, uri, appId, status=""):
        """
        Provided the base URL & App ID, it returns list of all operators which satisfy the 'state' criteria.
        If 'state' is not specified, returns all Operator IDs.
        :param uri: Base URL
        :param appId: App ID
        :param status: RUNNING, KILLED etc.
        :return: operator_ids
        """
        print "Status: <"+status+">"
        api = "applications/" + appId + "/physicalPlan/operators"
        self.get_api(uri, api, injson=True)
        if len(self.rjson["operators"]) == 0:
            raise AssertionError("No operators found!"+"\n"+"JSON:"+"\n"+str(self.rjson))
        operator_ids = []
        for i in range(0, len(self.rjson["operators"])):
            if status == "" or self.rjson["operators"][i]["status"] in status:
                operator_ids.append(self.rjson["operators"][i]["id"])
        return operator_ids

    def getOperatorNameFromId(self, uri, appid, opid):
        """
        Provided the base URL App ID & Operator ID, it returns the operator name
        :param uri: Base URL
        :param appId: App ID
        :param opId: Operator ID
        :return: opName
        """
        print "Operator ID: <"+opid+">"
        api = "applications/" + appid + "/physicalPlan/operators"
        self.get_api(uri, api, injson=True)
        if len(self.rjson["operators"]) == 0:
            raise AssertionError("No operators found!"+"\n"+"JSON:"+"\n"+str(self.rjson))
        for i in range(0, len(self.rjson["operators"])):
            if self.rjson["operators"][i]["id"] == opid:
                return self.rjson["operators"][i]["name"]
        print "ERROR: Operator ID "+opid+" not found!"

    def getOperatorPortsForApp(self, uri, appId, opId):
        """
        Provided the base URL, App ID & Operator ID, it returns list of all port names.
        :param uri: Base URL
        :param appId: App ID
        :param opId: Operator ID
        :return: ports: list of all port names
        """
        api = "applications/" + appId + "/physicalPlan/operators/" + opId + "/ports"
        self.get_api(uri, api, injson=True)
        if len(self.rjson["ports"]) == 0:
            raise AssertionError("No ports found!"+"\n"+"JSON:"+"\n"+str(self.rjson))
        ports = [self.rjson["ports"][i]["name"] for i in range(0, len(self.rjson["ports"]))]
        return ports

    def getOperatorRecordingsForApp(self, uri, appId, opId, ended=""):
        """
        Provided the base URL, App ID & Operator ID, it returns list of all recordings.
        :param uri: Base URL
        :param appId: App ID
        :param opId: Operator ID
        :return: recs: list of all recordings
        """
        print "ENDED=<"+ended+">"
        api = "applications/" + appId + "/physicalPlan/operators/" + opId + "/recordings"
        self.get_api(uri, api, injson=True)
        if len(self.rjson["recordings"]) == 0:
            # raise AssertionError("No recordings found!"+"\n"+"JSON: "+"\n"+str(self.rjson))
            pass
        recs = []   # recs = [self.rjson["recordings"][i]["id"] for i in range(0, len(self.rjson["recordings"]))]
        for i in range(0, len(self.rjson["recordings"])):
            if ended == '' or str(self.rjson["recordings"][i]["ended"]).lower() == ended:
                recs.append(self.rjson["recordings"][i]["id"])
        return recs

    def getOperatorRecordingWindowsForApp(self, uri, appId, opId, recId):
        """
        Provided the base URL, App ID & Operator ID, it returns list of all windows.
        :param uri: Base URL
        :param appId: App ID
        :param opId: Operator ID
        :param recId: Recording ID
        :return: wins: list of all windows
        """
        api = "applications/" + appId + "/physicalPlan/operators/" + opId + "/recordings/" + recId +"/tuples"
        self.get_api(uri, api, injson=True)
        if len(self.rjson["tuples"]) == 0:
            raise AssertionError("No windows found!"+"\n"+"JSON:"+"\n"+str(self.rjson))
        wins = [self.rjson["tuples"][i]["windowId"] for i in range(0, len(self.rjson["tuples"]))]
        return wins

    def getOperatorProperties(self, uri, app_id, op_id):
        api = "applications/" + app_id + "/physicalPlan/operators/" + op_id + "/properties"
        op_props = self.get_api(uri, api, injson=True)
        return op_props

    def getPhysicalOperatorDetails(self, uri, app_id, op_name, key=None):
        op_id = self.getOperatorIdFromOperatorName(uri, app_id, op_name)
        api = "applications/" + app_id + "/physicalPlan/operators/" + op_id
        op_details = self.get_api(uri, api, injson=True)
        if key is None:
            return op_details
        else:
            return op_details[key]

    def getLogicalOperatorDetails(self, uri, app_id, op_name, key=None):
        api = "applications/" + app_id + "/logicalPlan/operators/" + op_name
        op_details = self.get_api(uri, api, injson=True)
        if key is None:
            return op_details
        else:
            return op_details[key]

    def getValueFromJson(self, json_string, key1, key2=None):
        """
        Using the input json, returns value for the specified key/s
        :param json_string: Input json
        :param key1: key from the json string
        :param key2: key within key1 from the json string
        :return: value for the specified key
        """
        json_obj = json.loads(json_string)
        if key2 is None:
            return json_obj[key1]
        else:
            return json_obj[key1][key2]

    def createDictFromJson(self, json_string):
        """
        Creates python dictionary from input json string
        :param json_string: Input json
        :return: dictionary for input json
        """
        return json.loads(json_string)

    def findMatchingStrings(self, text, pattern):
        """
        Returns all the matching occurrences of pattern in the text
        :param text: String to be searched
        :param pattern: Regular expression for the pattern
        :return: results
        """
        results = re.findall(pattern, text)
        return results

    def compareLists(self, l1=list(), l2=list()):
        """
        Returns same output as python 'cmp' function after converting it to string
        :param l1:
        :param l2:
        :return: -1 or 0 or 1
        """
        l1.sort()
        l2.sort()
        return str(cmp(l1, l2))
