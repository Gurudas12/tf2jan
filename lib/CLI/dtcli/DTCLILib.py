import smtplib
import time
import re

class DTCLILib(object):
    """
        Test library for DTCLI commandline utility
    """
    def __init__(self):
        pass

    def send_email(self, a1,a2,a3,a4):
        localtime = time.asctime( time.localtime(time.time()) )
        sender = 'dttbc-vito-ingestion-test-run@node35.com'
        receivers = ['qa@datatorrent.com']
        message = "From: TESTBED <nagios@datatorrent.com>\n" \
            "To: QA <QA@datatorrent.com>\n" \
            "Subject: Finished Suite: "+a1+", Status: "+a2+", "+localtime+"\n\n" \
            "Finished Suite: "+a1+", Status: "+a2+"\n" \
            "\n"+a3+"\n\n"+a4

        smtpObj = smtplib.SMTP('localhost')
        smtpObj.sendmail(sender, receivers, message)
        print "Successfully sent email (DTCLI)!!"

    def remove_line_from_string(self, strn, index):
        if strn == "":
            return strn
        index = int(index)
        strn_arr = strn.split("\n")
        del strn_arr[index]
        strn = "\n".join(strn_arr)
        return strn

    def get_containers(self, strn, pattern=""):
        lines = strn.split("\n")
        cont = []
        flag = 0
        c = s = ""
        for line in lines:
            m1 = re.match(".+\"id\": \"(\w+)\".+", line)
            m2 = re.match(".+\"state\": \"(\w+)\".+", line)
            if m1:
                flag += 1
                c = m1.group(1)
            if m2:
                s = m2.group(1)
                flag += 1
            if flag == 2:
                flag = 0
                if pattern == "" or s == pattern:
                    cont.append(c)
        return cont

    def get_app_list(self, strn, pattern=""):
        lines = strn.split("\n")
        apps = []
        flag = 0
        i = a = s = ""
        for line in lines:
            m1 = re.match(".+\"id\": (\w+).+", line)
            m2 = re.match(".+\"state\": \"(\w+)\".+", line)
            m3 = re.match(".+\"trackingUrl\": .+(application_\w+_\w+)", line)
            if m1:
                flag += 1
                i = m1.group(1)
            if m2:
                s = m2.group(1)
                flag += 1
            if m3:
                a = m3.group(1)
                flag += 1
            if flag == 3:
                flag = 0
                if pattern == "" or s == pattern:
                    apps.append(a)
        return apps

    def get_app_list_depr1(self, strn, pattern=""):
        lines = strn.split("\n")
        apps = []
        flag = 0
        a = s = ""
        for line in lines:
            m1 = re.match(".+\"id\": \"(\w+)\".+", line)
            m2 = re.match(".+\"state\": \"(\w+)\".+", line)
            if m1:
                flag += 1
                a = m1.group(1)
            if m2:
                s = m2.group(1)
                flag += 1
            if flag == 2:
                flag = 0
                if pattern == "" or s == pattern:
                    apps.append(a)
        return apps

    def get_app_list_depr(self, str):
        lines = str.split("\n")
        apps = []
        for line in lines:
            m = re.match(".+(application_\w+).+", line)
            if m:
                print 'Match found: ', m.group(1)
                apps.append(m.group(1))
        return apps
