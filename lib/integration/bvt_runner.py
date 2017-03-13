from testopia import Testopia
import sys
import re
import MySQLdb

class BVTRunner: 
	# Class creates new test run for BVT plan and triggers it
        #
	def __init__(self):
		yaml_data = {}
		testrun_details = None
		pass

	def create_test_run(self, build_version):
	# Function to create new test run for BVT 
	# Assumptions:
	#	product_id for SPOI : 2
	#	BVT test_plan id : 3

		tcmscon = Testopia.from_config('/var/dt/tf/etc/testopia.cfg')
		build_id = 0
                product_version = ''

		try:
			build_details = tcmscon.build_check_by_name( build_version , 2)
			build_id = build_details['build_id']
		except Exception:
			new_created_build_id = tcmscon.build_create( name=build_version, product_id=2 )
			build_id = new_created_build_id['build_id']
			
		env_details = tcmscon.environment_check_by_name('bvt',2)
		env_id = env_details['environment_id']
		print " Test run parameter details : %d %d " %  (build_id, env_id)
                db = MySQLdb.connect("localhost","bugzilla","bugzpass","bugzilla" )
                cursor = db.cursor()
                mystr = build_version
                sql = "SELECT id FROM versions WHERE product_id = '%d' and value like '%s'" %(2,mystr)
                cursor.execute(sql)
                results = cursor.fetchone()
                row_count = cursor.rowcount
                print("number of affected rows: {}".format(row_count))
                if row_count == 0:
                    print("This product version does not exist: {}".format(mystr))
                    print("Going to add this version {}".format(mystr))
                    sql = "INSERT INTO versions (value,product_id,isactive) VALUES ('%s',2,1)" %(mystr,)
                    try:
                        cursor.execute(sql)
                        db.commit()
                        sql = "SELECT id FROM versions WHERE product_id = '%d' and value like '%s'" %(2,mystr)
                        cursor.execute(sql)
                        results = cursor.fetchone()

                    except:
                        db.rollback()
                db.close()
                product_versionid = results[0]
	
		#Create new testrun for BVT
		from time import gmtime, strftime
		showtime = strftime("%Y-%m-%d_%H:%M:%S", gmtime())
		testrun_details = tcmscon.testrun_create(build_id=build_id, environment_id=env_id, plan_id=3, summary=("Build_Verification_Tests_%d_%s" % (build_id,showtime)) , product_version=mystr, manager_id=1)

		#Add test cases from BVT test plan to created test cases
		tlist = tcmscon.testplan_get_test_cases(3)
		for i in range (0, len(tlist)):
			tcmscon.testcaserun_create(case_id=tlist[i]['case_id'], assignee=1, build_id=build_id, environment_id=env_id, run_id=testrun_details['run_id'])
		#tcmscon.testcaserun_create(case_id=1049, assignee=1, build_id=9, environment_id=17, run_id=187)
		tcmscon = None
		print testrun_details['run_id']
		return testrun_details['run_id']

	
	def _wait_for_test_run_execution(self, run_id):
		import time, os
		#Wait for BVT test run complition 
		fileName = "/var/dt/tf/logs/" + run_id + "/index.html"
		while True:
		     if os.path.isfile(fileName) is True:
        		     break
		     #Sleeps for 10 seconds to let test run gets completed
		     time.sleep(10)		

	def start_bvt_run(self, run_id):
		tcmscon = Testopia.from_config('/var/dt/tf/etc/testopia.cfg')
		# Retrieve test cases list from given test run 
		test_cases_list = tcmscon.testrun_get_test_cases( run_id )
		print test_cases_list
		
		test_run_details = tcmscon.testrun_get( run_id )
		yaml_deploy_data = {}
		yaml_deploy_data['test_run'] = {}
		yaml_deploy_data['test_run']['cases'] = {}
		yaml_data = {}
		yaml_data['test_run'] = {}
		yaml_data['test_run']['cases'] = {}
		
		#Run deployment test first
		for i in range (0, len(test_cases_list)):
			if test_cases_list[i]['summary'] == "1_DT_Installation_Configuration":
				case_id = test_cases_list[i]['case_id']
				yaml_deploy_data['test_run']['cases'][case_id] = {}
	                        yaml_deploy_data['test_run']['cases'][case_id]['summary'] = test_cases_list[i]['summary']
        	                yaml_deploy_data['test_run']['cases'][case_id]['case_id'] = case_id
                	        yaml_deploy_data['test_run']['cases'][case_id]['isautomated'] = test_cases_list[i]['isautomated']
		                yaml_deploy_data['test_run']['plan_id'] = test_run_details['plan_id']
		yaml_deploy_data['test_run']['plan_id'] = test_run_details['plan_id']
		yaml_deploy_data['test_run']['run_id'] = run_id
		yaml_deploy_data['test_run']['environment_id'] = test_run_details['environment_id']
		yaml_deploy_data['test_run']['summary'] = test_run_details['summary']

		#Create run file for DT installation and configuration test
		import yaml
		fileName = "/var/dt/tf/tmp/bugzilla/%s" % (run_id)
		print "BVT installation test starts ...."
		
		with open(fileName, 'w') as yaml_file:
                        yaml.dump(yaml_deploy_data, yaml_file, default_flow_style=False, explicit_start=True)
		print "yaml file created"
		
		self._wait_for_test_run_execution(str(run_id))
		print "End of Deployment test execution \n"
		

		#Prepare dict to dump in yaml from test_cases_list
		for i in range (0, len(test_cases_list)):
			if test_cases_list[i]['summary'] != "1_DT_Installation_Configuration":
				case_id = test_cases_list[i]['case_id']			
				yaml_data['test_run']['cases'][case_id] = {}
				yaml_data['test_run']['cases'][case_id]['summary'] = test_cases_list[i]['summary']
				yaml_data['test_run']['cases'][case_id]['case_id'] = case_id
				yaml_data['test_run']['cases'][case_id]['isautomated'] = test_cases_list[i]['isautomated']
		yaml_data['test_run']['plan_id'] = test_run_details['plan_id']
		yaml_data['test_run']['run_id'] = run_id
		yaml_data['test_run']['environment_id'] = test_run_details['environment_id']
		yaml_data['test_run']['summary'] = test_run_details['summary']

		#Delete and create run file to trigger the BVT run
		import os
		os.remove(fileName)	
		print "BVT run starts ...."
		with open(fileName, 'w') as yaml_file:
			yaml.dump(yaml_data, yaml_file, default_flow_style=False, explicit_start=True)
		
		#self._wait_for_test_run_execution(str(run_id))
		#Wait for all tests to get executed; check for file timestamp   
		ts1 = os.stat("/var/dt/tf/logs/" + str(run_id) + "/index.html").st_mtime
                import time
		while True:
			time.sleep(2700) #Explicit wait to get execution completed 
			if ts1 != os.stat("/var/dt/tf/logs/" + str(run_id) + "/index.html").st_mtime :
				break	
		
		print "End of BVT execution \n"
		tcmscon = None


if __name__ == "__main__" :
	obj = BVTRunner()
	build_version = sys.argv[1]
	#Replace build_version in server env file
	with open('/var/dt/tf/etc/environments/server.py', 'r') as fd:
		lines = fd.readlines()

	#Replacing default value as 3.2.0 with given build_version
	for i in range(0,len(lines)-1):
        	if ( re.match(r'dt_version = (.*)', lines[i], re.I) ):
                	lines[i] = re.sub(r'dt_version = (.*)', "dt_version = '" + build_version + "'" , lines[i] )
			break

	with open('/var/dt/tf/etc/environments/server.py', 'w') as fd:
		fd.write(''.join(lines))
		
			
	run_id = obj.create_test_run(str(build_version))
	print "Test run created : "+ str(run_id)
	obj.start_bvt_run(run_id)

	print "BVT run report:  http://vito.morado.com/logs/" + str(run_id)
