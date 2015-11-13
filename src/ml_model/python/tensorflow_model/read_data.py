import sys
sys.path.append('/usr/local/lib/python2.7/dist-packages/')

import tensorflow as tf

filename_queue = tf.train.string_input_producer(["../../../../data/clean_data_no_header.csv"])
#filename_queue = tf.train.string_input_producer(["file0.csv"])

reader = tf.TextLineReader()
key, value = reader.read(filename_queue)

# Default values, in case of empty columns. Also specifies the type of the
# decoded result.
record_defaults = [[1.]] * 38
col1, col2, col3, col4, col5, col6, col7,col8, col9, col10,col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21,col22, col23, col24, col225, col26, col27, col28, col29, col30, col31, col32, col33, col34, col35, col36, col37, col38 = tf.decode_csv(value, record_defaults = record_defaults)

features = tf.concat(0, [col1, col2, col3, col4, col5, col6, col7,col8, col9, col10,col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21,col22, col23, col24, col225, col26, col27, col28, col29, col30, col31, col32, col33, col34, col35, col36, col37])

#record_defaults = [[1], [1], [1], [1], [1]]
#col1, col2, col3, col4, col5 = tf.decode_csv(value, record_defaults=record_defaults)
#features = tf.concat(0, [col1, col2, col3, col4])

with tf.Session() as sess:
    # Start populating the filename queue.
    coord = tf.train.Coordinator()
    threads = tf.train.start_queue_runners(coord=coord)

    for i in range(1200):
        # Retrieve a single instance:
        example, label = sess.run([features, col38])
        #example, label = sess.run([features, col5])
        print(label)

    coord.request_stop()
    coord.join(threads)
