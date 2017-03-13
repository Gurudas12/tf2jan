from hdfs import InsecureClient


class HDFSLibrary:
    """
        Test library for working with HDFS
    """
    WEB_HDFS_URL = ""
    client = ""

    def __init__(self, namenode="localhost", port="50070"):
        self.WEB_HDFS_URL = 'http://' + namenode + ':' + str(port)
        print namenode,">>",port,">>",self.WEB_HDFS_URL
        self.client = InsecureClient(self.WEB_HDFS_URL)

    def check_hdfs_file_exists(self, file_path, stop=False):
        if None == self.client.status(file_path, strict=False):
            if stop:
                print "ERROR: Error: File does not exist: ", file_path
                return "ERROR: Error: File does not exist: ", file_path
                # exit(172)
            return False
        return True

    def get_hdfs_file_content(self, file_path):
        self.check_hdfs_file_exists(file_path, stop=True)
        data = ""
        with self.client.read(file_path) as reader:
            for line in reader:
                data += line
        return data

    def search_string_in_hdfs_file(self, file_path, text1, text2="aqwszx", text3="xzswqa"):
        ret = self.check_hdfs_file_exists(file_path, stop=True)
        found = "" if ret else ret
        with self.client.read(file_path) as reader:
            for line in reader:
                if line.find(text1) == -1 and line.find(text2) == -1 and line.find(text3) == -1:
                    continue
                found += line
        return found

    def hdfs_file_should_not_contain(self, file_path, text1, text2="aqwszx", text3="xzswqa"):
        self.check_hdfs_file_exists(file_path, stop=True)
        with self.client.read(file_path) as reader:
            for line in reader:
                if line.find(text1) != -1 or line.find(text2) != -1 or line.find(text3) != -1:
                    return False
        return True

    ########################
    # # BASIC FUNCTIONS: # #
    ########################
    def get_hdfs_file_folder_content_summary(self, file_path):
        """
        Retrieving a file or folder content summary.
        :return: returns a file or folder content summary.
        """
        self.check_hdfs_file_exists(file_path, stop=True)
        return self.client.content(file_path)

    def get_hdfs_file_folder_status(self, file_path):
        """
        Retrieving a file or folder status.
        :return: returns a file or folder status.
        """
        self.check_hdfs_file_exists(file_path, stop=True)
        return self.client.status(file_path)

    def list_hdfs_directory(self, folder_path):
        """
        Listing all files inside a directory.
        :return: returns a file list.
        """
        self.check_hdfs_file_exists(folder_path, stop=True)
        return self.client.list(folder_path)

    def move_hdfs_file(self, old_path, new_path):
        """
        Renaming ("moving") a file.
        :return: NA
        """
        self.check_hdfs_file_exists(old_path, stop=True)
        self.client.rename(old_path, new_path)

    def delete_hdfs_file(self, file_path):
        """
        Deleting a file or folder recursively.
        :return: returns `True` if the deletion was successful otherwise `False`
        """
        self.check_hdfs_file_exists(file_path)
        return self.client.delete(file_path, recursive=True)

    def copy_to_local_hdfs_file(self, hdfs_path, local_path):
        """
        Copy a file or folder from HDFS to local.
        :return: local_path
        """
        self.check_hdfs_file_exists(hdfs_path)
        return self.client.download(hdfs_path, local_path, overwrite=True, n_threads=4)

    def copy_from_local_hdfs_file(self, local_path, hdfs_path):
        """
        Copy a file or folder from local to HDFS.
        :return: hdfs_path
        """
        return self.client.upload(hdfs_path, local_path, overwrite=True, n_threads=4)

    def get_hdfs_file_checksum(self, file_path):
        """
        Get the checksum value for file
        :return: checksum
        """
        self.check_hdfs_file_exists(file_path, stop=True)
        return self.client.checksum(file_path)

    def create_hdfs_dir(self, dir_path, perm=755):
        """
        Create a directory or recursive dirs on HDFS
        :return: NA
        """
        self.client.makedirs(dir_path, permission=perm)
