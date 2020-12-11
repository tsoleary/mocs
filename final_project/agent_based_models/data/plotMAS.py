import matplotlib.pyplot as plt
import numpy as np
import sys

try:
    hyperparams = []
    #file = input("file: ")
    file = sys.argv[1]
    print(file)
    unproc = open(file + ".log")
    data = []
    counter = 0
    for line in unproc:
        #if counter > 3000:
        #    break
        spltline = line.split()

        counter += 1
        #print(spltline)
        if len(spltline) >= 6:
            try:
            

                float(spltline[2])
                hyperparams = spltline[1:]
                #print(spltline)
            except:
                pass
                #print("hyperparams except")

        elif (len(spltline) >= 4):
            try:
                if (int(spltline[1]) != 0 and int(spltline[2]) != 0):
                    data.append(
                        [int(spltline[1]),
                         int(spltline[2]),
                         int(spltline[3])
                        ]
                    )
            except:
                pass

    data = np.array(data)
    #print(hyperparams)
    #     console.log(chancePredator, spec0StarveTime, spec0reproductionRate, spec1reproductionRate, totalPop);

    
    '''
    plt.fill_between(data[:, 0], data[:, 1], color="#9A1313", alpha=1, linewidth=2, label="pred")
    plt.fill_between(data[:, 0], data[:, 2], color="#139A92", alpha=1, linewidth=2, label="prey")
    '''

    plt.plot(data[:, 0], data[:, 1], color="#9A1313", alpha=1, linewidth=2, label="pred")
    plt.plot(data[:, 0], data[:, 2], color="#139A92", alpha=1, linewidth=2, label="prey")
    plt.title("Cannibalism=" + hyperparams[0] +
              ", chance pred=" + hyperparams[1] +
              ", pred starve time=" + hyperparams[2] +
              ", pred repr rate=" + hyperparams[3] +
              ", prey repr rate=" + hyperparams[4] +
              ", init pop=" + hyperparams[5]
    ) 
    plt.xlabel("Iterations")
    plt.ylabel("Population")
    plt.legend()

    plt.show()


except FileNotFoundError:
    print("file not found")

