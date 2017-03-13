__author__ = 'akshay'


#from Selenium2Library import Selenium2Library
import re
from robot.api import logger


class WebCommon:

    def verify_license_info(self, license_info):

        string_data = dict([(str(k), str(v)) for k,v in license_info.items()])

        logger.info(" ##%s## ##%s## " % (string_data['License Edition'].strip(), string_data['License Type'].strip() ))
        if ((string_data['License Edition'].strip() == 'enterprise') and (string_data['License Type'].strip() == 'evaluation')):
            logger.info(" ##%s## " %  (string_data['License ID'].strip()))
            if re.match(r'^anon', string_data['License ID'].strip(), re.I)  is not None:
                    logger.debug("Found default license - ID : %s and valid upto: %s" % ( string_data['License ID'], string_data['Expiration Date']))
            else:
                    logger.error("Invalid datatorrent license ID")
                    return 1
        else:
            logger.error("Invalid datatorrent license information")
            return 1

        return 0
