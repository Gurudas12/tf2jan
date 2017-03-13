import json
from testopia import Testopia
import sys


class ProtractorReporter:
	# The reporter for protractor tests; integration with Bugzilla
        #

	protractor_report_json = None
        tests_result = None
	no_of_tests = None
	
	# Test run for protractor tests
	run_id = 173

	def __init__(self, jsonFile):
  		 protractor_report_json = jsonFile
		 json_data = open(jsonFile)
		 self.tests_result = json.load(json_data)
 		 json_data.close()
   
	def update_tests_run_status(self):
                # Function uploads the protractor tests result to Bugzilla against created test run
		self.no_of_tests = len(self.tests_result)
		if self.no_of_tests is not 0:
 			tcmscon = Testopia.from_config('/var/dt/tf/etc/testopia.cfg')
			#Get Test run details : build_id, environment_id
			testrun_detail_list = tcmscon.testrun_get(self.run_id)
			build_id = testrun_detail_list['build_id']
			env_id = testrun_detail_list['environment_id']
			print "Test run details : %s %s " % (build_id, env_id)
		
			for i in range(self.no_of_tests):
				test_summary = str(self.tests_result[i]['description'])
				testrun_result = str(self.tests_result[i]['assertions'][0]['passed'])

				test_detail_list = tcmscon.testrun_list( run_id=self.run_id, summary=test_summary )
				case_id = test_detail_list[0]['case_id']
				
				print "Result : %s %s " % (test_summary,testrun_result)
				if testrun_result is "True":
					tcmscon.testcaserun_update(run_id=self.run_id,\
							           case_id=case_id, build_id=build_id, \
    						                   environment_id=env_id, case_run_status_id=2)
				else:
					tcmscon.testcaserun_update(run_id=self.run_id,\
							           case_id=case_id, build_id=build_id, \
    						                   environment_id=env_id, case_run_status_id=3)

				test_summary = ""
				testrun_result = ""
				test_detail_list = ""
				case_id = ""
			tcmscon = None
		else:
			print >> sys.stderr, "No test results found in %s" % (self.protractor_report_json)


if __name__ == "__main__":
	if (len(sys.argv) > 1 ):
        	json_file_location = sys.argv[1]
		obj = ProtractorReporter(json_file_location)
		obj.update_tests_run_status()
	else:
		print "Please specify json file with absolute path!!"
	
