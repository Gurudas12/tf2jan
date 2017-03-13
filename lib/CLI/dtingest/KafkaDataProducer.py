from kafka import KeyedProducer, KafkaClient, RoundRobinPartitioner, SimpleProducer
from datetime import datetime
import time,sys
from robot.api import logger

class KafkaDataProducer:

   def send_to_kafka(self, kafka_client, is_multi_partitioner, noOfMsgs, topic, msg_interval=1):
        """
        This function sends the dummy messages to Kafka server
        :param kafka_client:
        :param is_multi_partitioner: True if multi-partitioned kafka; False if single partition
        :param noOfMsgs: Number messages to be sent to Kafka
        :param topic: Name of Kafka topic
        :param msg_interval: Interval time for message to be sent
        :return: None
        """

        kafka = KafkaClient(kafka_client)
        #logger.debug("Arguments :  %s %s %s %s %s" % (kafka_client, is_multi_partitioner, noOfMsgs, topic, msg_interval))

        if is_multi_partitioner is True:
            self.producer = KeyedProducer( kafka, partitioner=RoundRobinPartitioner )
            if ( noOfMsgs == -1 ):
                x=1
                while True:
                    self.producer.send_messages(topic, "key"+str(x), "Message sent from Keyed Producer : " + str(datetime.now().time()))
                    x += 1
                    time.sleep(msg_interval)
            else:
                for i in range(0, noOfMsgs):
                    self.producer.send_messages(topic, "k" + str(i), "Message sent from Keyed Producer : " + str(datetime.now().time()) )

        else:
            self.producer = SimpleProducer(kafka)
            if ( noOfMsgs == -1 ):
                x=1
                while True:
                    self.producer.send_messages(topic, "Message sent from Simple Producer : " + str(datetime.now().time()))
                    x += 1
                    time.sleep(msg_interval)
            else:
                for i in range(0, noOfMsgs):
                    self.producer.send_messages(topic, "Message sent from Simple Producer : " + str(datetime.now().time()) )


if __name__ == "__main__":
    kafka_broker_addr = sys.argv[1]
    is_multi_partitioner = sys.argv[2]
    no_of_msgs = int(sys.argv[3])
    kafka_topic = sys.argv[4]
    if sys.argv[5] is not None:
        msg_interval = int(sys.argv[5])
    else:
        msg_interval = 1

    print "Arguments :  %s %s %d %s %d" % (kafka_broker_addr, is_multi_partitioner, no_of_msgs, kafka_topic, msg_interval)

    producer = KafkaDataProducer()
    producer.send_to_kafka(kafka_broker_addr, is_multi_partitioner, no_of_msgs, kafka_topic, msg_interval)
