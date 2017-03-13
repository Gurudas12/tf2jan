import re
from SSHLibrary import SSHLibrary
import smtplib
import time

class DTCPLib(object):
    """
        Test library for DTCP commandline utility
    """
    def __init__(self):
        pass

    @staticmethod
    def getprotocol(path):
        m = re.search('([^\:]+)', path)
        if m:
            protocol = m.groups()[0]
            return protocol
        else:
            print "Invalid path provided for input source. No protocol found.\n"
            exit(172)

    @staticmethod
    def includefile(file_name, perm, f_filter):
        if f_filter=="" or perm.startswith("d"):
            return True
        m = re.search(f_filter, file_name)
        if m:
            return True
        else:
            return False

    @staticmethod
    def updatefilter(f):
        if f != "":
            print "Incoming File Filter :", f
            # Replace "." with "\."    ORDER of REPLACEMENTS MATTERS
            # Replace "*" with ".*"
            # Add "$" at the end
            f = re.sub('\.','\.', f)
            f = re.sub('\*','.*', f)
            f += "$"
            print "Modified File Filter :", f
        return f

    @staticmethod
    def get_ftp_server_info(path):
        m = re.search('ftp://(.+):(.+)@(.+):(\d+)', path)
        if m:
            ftpuser = m.groups()[0]
            ftppswd = m.groups()[1]
            ftpsrvr = m.groups()[2]
            ftpport = m.groups()[3]
            print ftpuser, ftppswd, ftpsrvr, ftpport
            print "Changing server address to", ftpsrvr, "for FTP"
            return ftpsrvr
        else:
            print "Invalid FTP URI: ", path
            exit(41)

    @staticmethod
    def prepare_vars_2(path, protocol):
        cmd = "ls /dev/null"
        p_i = s_i = n_i = None
        if protocol == "hdfs":
            cmd = "/usr/local/hadoop/bin/hdfs dfs -ls -R %s" % (path)
            cmd = "hdfs dfs -ls -R %s" % (path)
            p_i = 0
            s_i = 4
            n_i = 7
        elif protocol == "ftp":
            #path = re.sub('ftp://.+:.+@.+:\d+', '/home/ftp-dttbc', path)
            path = re.sub('ftp://.+:.+@.+:\d+', '', path)
            cmd = "sudo find %s | sudo xargs ls -ld" % (path)
            p_i = 0
            s_i = 4
            n_i = 8
        elif protocol == "file":
            path = path.replace("file://", "")
            cmd = "find %s | xargs ls -ld" % (path)
            p_i = 0
            s_i = 4
            n_i = 8
        elif protocol == "s3n":
            path = path.replace("s3n:", "s3:")
            path = re.sub('\w+:\w+@', '', path)
            path = re.sub('\/$','', path)
            cmd = "s3cmd ls -r %s" % (path)
            p_i = 0
            s_i = 2
            n_i = 3
        else:
            print "Unknown protocol"
        print "CMD:", cmd
        return path, cmd, p_i, s_i, n_i

    @staticmethod
    def prepare_vars_1(path, protocol):
        cmd = "ls /dev/null"
        p_i = s_i = n_i = None
        if protocol == "hdfs":
            cmd = "/usr/local/hadoop/bin/hdfs dfs -ls -d %s" % (path)
            cmd = "hdfs dfs -ls -d %s" % (path)
            p_i = 0
            s_i = 4
            n_i = 7
        elif protocol == "ftp":
            #path = re.sub('ftp://.+:.+@.+:\d+', '/home/ftp-dttbc', path)
            path = re.sub('ftp://.+:.+@.+:\d+', '', path)
            cmd = "sudo ls -ld %s" % (path)
            p_i = 0
            s_i = 4
            n_i = 8
        elif protocol == "file":
            path = path.replace("file://", "")
            cmd = "ls -ld %s" % (path)
            p_i = 0
            s_i = 4
            n_i = 8
        elif protocol == "s3n":
            path = path.replace("s3n:", "s3:")
            path = re.sub('\w+:\w+@', '', path)
            path = re.sub('\/$','', path)
            cmd = "s3cmd ls %s" % (path)
            p_i = 0
            s_i = 2
            n_i = 3
        else:
            print "Unknown protocol1"
        print "CMD:", cmd
        return path, cmd, p_i, s_i, n_i

    @staticmethod
    def send_email(self, a1, a2, a3, a4):
        localtime = time.asctime( time.localtime(time.time()) )
        sender = 'nagios@datatorrent.com'
        receivers = ['qa@datatorrent.com']
        message = "From: TESTBED <dttbc@qa-cluster.com>\n" \
            "To: QA <QA@datatorrent.com.com>\n" \
            "Subject: Finished Suite: "+a1+", Status: "+a2+", "+localtime+"\n\n" \
            "Finished Suite: "+a1+", Status: "+a2+"\n" \
            "\n"+a3+"\n\n"+a4

        smtp_obj = smtplib.SMTP('localhost')
        smtp_obj.sendmail(sender, receivers, message)
        print "Successfully sent email!!"

    def get_size_metadata(self, path, server, uname, psky, issource, file_filter="", separator=" "):
        print "ALL PATHS:", path
        file_listing = dict()
        file_filter = self.updatefilter(file_filter)

        paths = path.split(separator)
        protocol = self.getprotocol(paths[0])
        print "PROTOCOL: " + protocol

        # For ftp input path, change original server to ftp server:
        if protocol == "ftp":
            server = self.get_ftp_server_info(path)
        obj = self.create_ssh_connection(server, uname, psky)

        for path in paths:
            print "Processing path: "+ path
            path = re.sub('/$','', path)
            base = path.split("/")[-1]
            print "BASE: " + base
            isdir = True; p_i = s_i = n_i = -1

            # if the input is from SOURCE and is a directory, then add a key for base directory
            if issource == "1":
                path, cmd, p_i, s_i, n_i = self.prepare_vars_1(path, protocol)
                print "path, cmd, p_i, s_i, n_i :::", path, cmd, p_i, s_i, n_i, "\n"
                output = str(obj.execute_command(cmd))
                print "OUTPUT:\n", output
                output = ' '.join(output.split())
                attr = output.split(" ")
                perm = attr[p_i]
                #name = attr[n_i]
                isdir = True if perm.startswith("d") or perm == "DIR" else False
                size = "0" if isdir else attr[s_i]
                if not(protocol == "file" and isdir) and self.includefile("/"+base, perm, file_filter):
                    file_listing["/"+base] = size
                    print "Added: /"+base+" : " + size + "\n"

            if isdir:
                path, cmd, p_i, s_i, n_i = self.prepare_vars_2(path, protocol)
                output = obj.execute_command(cmd)
                print "OUTPUT:\n", output
                lines = output.split("\n")
                for line in lines:
                    line = ' '.join(line.split())
                    attr = line.split(" ")
                    perm = attr[p_i]
                    if len(perm) < 10 or len(perm) > 11:
                        continue
                    size = "0" if perm.startswith("d") else attr[s_i]
                    name = ' '.join(attr[n_i:])
                    name = name.replace(path, "")
                    if name == "/" :
                        continue;
                    if issource == "1" :
                        name = "/" + base + name
                    if name != "" and self.includefile(name, perm, file_filter):
                        file_listing[name] = size
                        print "Added: "+name+" : " + size + "\n"

        if protocol == "ftp":
            output = str(obj.execute_command("exit"))
            print "OUTPUT:\n", output

        return file_listing

    def create_ssh_connection(self, server, uname, psky):
        obj = SSHLibrary()
        obj.open_connection(server)
        obj.login_with_public_key(uname, psky)
        return obj

    def filter_out_dictionary(self, dct, regex):
        # print "Dictionary:", dct
        regex = self.updatefilter(regex)
        print "Removing keys which match:",regex
        ret = dict()
        for key in dct:
            m = re.search(regex, key)
            if not m:
                key1 = re.sub('_REMOVE$','', key)   # remove the tag added in decompress code
                ret[key1] = dct[key]
                print "KEY:", key1, "ADDED"
        return ret

    def decompress_on_hdfs(self, dirpath, server, uname, psky):
        obj = self.create_ssh_connection(server, uname, psky)

        cmd = "hdfs dfs -ls -R %s | grep \"\.gz$\" " % dirpath
        print "CMD:", cmd
        output = obj.execute_command(cmd)
        print "OUTPUT:\n", output,"\n"
        lines = output.split("\n")

        for line in lines:
            print "For:", line
            line = ' '.join(line.split())
            attr = line.split(" ")
            print "<"+attr[0]+">"
            if len(attr[0]) < 10 or len(attr[0]) > 11: continue
            gz_name = ''.join(attr[7:])
            ugz_name = re.sub('\.gz$','_REMOVE', gz_name)   # just to tag the unzipped files from this code
            cmd = "hdfs dfs -text %s | hdfs dfs -put - %s" % (gz_name, ugz_name)
            print "Unzip command:", cmd
            output = str(obj.execute_command(cmd))

        ret_dct = self.get_size_metadata(dirpath, server, uname, psky, 0)
        ret_dct = self.filter_out_dictionary(ret_dct, "*.gz")
        return ret_dct

    def add_update_files_on_hdfs(self, dirpath, server, uname, psky, add=1, update=1):
        obj = self.create_ssh_connection(server, uname, psky)

        if update==1 :
            local_file = "/tmp/ing-tmp-file"
            cmd = " echo \"Date is `date`\" > %s" % local_file
            obj.execute_command(cmd)

        cmd = "hdfs dfs -ls -R %s | grep \"^-\" | awk '{print $8}' " % dirpath
        print "CMD:", cmd
        output = obj.execute_command(cmd)
        print "Output:", output
        lines = output.split("\n")

        #If #files is large, update only few files:
        n_lines = []
        if len(lines) > 10 :
            factor = len(lines) / 5
            for i in range(0, len(lines), factor):
                n_lines.append(lines[i])
            lines = n_lines

        for f_name in lines:
            print f_name
            if add==1 :
                new_f_name = f_name+"_copy"
                cmd = "hdfs dfs -cp %s %s" % (f_name, new_f_name)
                print "File add command:", cmd
                obj.execute_command(cmd)
            if update==1 :
                cmd = "hdfs dfs -appendToFile %s %s" % (local_file, f_name)
                print "Update command:", cmd
                obj.execute_command(cmd)




