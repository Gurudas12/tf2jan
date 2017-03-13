from kafka import KeyedProducer, KafkaClient, RoundRobinPartitioner, SimpleProducer
from datetime import datetime
import time


class KafkaLibrary:
    """Library for working with Kafka
    """
    broker = ""
    zookeper = ""

    def __init__(self, broker, zookeeper):
        self.broker = broker
        self.zookeper = zookeeper

    def send_messages_to_kafka(self, topic, num_msgs=-1, msg_len=70, msg_interval=0.1, is_multi=True, write=True):
        """
        This function sends dummy messages to Kafka
        :param topic: Name of Kafka topic
        :param num_msgs: Number messages to be sent to Kafka
        :param msg_len: Length of the message
        :param msg_interval: Interval time for message to be sent
        :param is_multi: True if multi-partitioned kafka; False if single partition
        :return: None
        """
        print "Topic:", topic, "#msgs=", num_msgs, "len=", msg_len, "int=", msg_interval, "mult=", is_multi, "w=", write

        if write:
            out = open("/tmp/kafka-input-module-msgs.log", "w")

        kafka_client = KafkaClient(self.broker)
        if is_multi:
            producer = KeyedProducer(kafka_client, partitioner=RoundRobinPartitioner)
            producer_type = 'KeyedProducer'
        else:
            producer = SimpleProducer(kafka_client)
            producer_type = 'SimpleProducer'

        count = 0
        num_msgs = int(num_msgs)
        while count != num_msgs:
            count += 1
            msg = str(count) + ": Message from " + producer_type + " : " + str(datetime.now()) + " " + "#"*msg_len
            msg = msg[:msg_len]
            if is_multi:
                producer.send_messages(topic, "key"+str(count), msg)
            else:
                producer.send_messages(topic, msg)
            if write:
                out.write(msg+"\n")
            time.sleep(msg_interval)
        print "Sent", count, "messages!!"