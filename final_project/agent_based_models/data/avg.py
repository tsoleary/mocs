import matplotlib.pyplot as plt
import sys
def main():
    plot_type = sys.argv[1]

    cann_types = ["none", "const", "omni", "hgry"]

    print("\t Pred Rem \t Prey Rem \t Final Round")

    plot_pred = []
    plot_prey = []
    plot_final_round = []

    for cann_type in cann_types:
        rem_pred = []
        rem_prey = []
        final_round = []
        last_data_points = []
        
        for i in range(1,21):
            try:
                file = open(cann_type + str(i) + ".log")
                data = get_data(file)
            
                last_data_points.append((data[-1]))
            except:
                print("File not found")

        for elem in last_data_points:
        
            rem_pred.append(int(elem[1]))
            rem_prey.append(int(elem[2]))
            final_round.append(int(elem[0]))

        plot_pred.append(rem_pred)
        plot_prey.append(rem_prey)
        plot_final_round.append(final_round)

        print(rem_pred)
            
        print(
            cann_type.upper(),
            "      ",
            get_avg(1,last_data_points),
            "          ",
            0,
            "             ",
            get_avg(0,last_data_points)
        )

    if plot_type == "Pred":
        make_box_plot("Pred Remaining", plot_pred)
    elif plot_type == "Prey":
        make_box_plot("Pred Remaining", plot_prey)
    else:
        make_box_plot("Iters", plot_final_round)
    
    
def make_box_plot(title, data):
    plt.title(title)
    fig = plt.figure(1, figsize=(9, 6))
    ax = fig.add_subplot(111)
    bp = ax.boxplot(data, patch_artist=True)

    for box in bp['boxes']:
        # change outline color
        box.set( color='#7570b3', linewidth=2)
        # change fill color
        if title.split()[0] == "Pred":
            box.set( facecolor = '#9A1313' )
        if title.split()[0] == "Prey":
            box.set( facecolor = '#139A92' )

    ## change color and linewidth of the whiskers
    for whisker in bp['whiskers']:
        whisker.set(color='#7570b3', linewidth=2)
        
    ## change color and linewidth of the caps
    for cap in bp['caps']:
        cap.set(color='#7570b3', linewidth=2)

    ## change color and linewidth of the medians
    for median in bp['medians']:
        median.set(color='#b2df8a', linewidth=2)

    ## change the style of fliers and their fill
    for flier in bp['fliers']:
        flier.set(marker='o', color='#e7298a', alpha=0.5)

    ax.set_xticklabels(['NONE', 'CONST', 'OMNI', 'HGRY'])
    
    plt.show()

    

def get_avg(ind, data_points):
    sum = 0
    for line in data_points:
        sum += int(line[ind])

    return int(sum/len(data_points))


def get_data(file):
    lines = [line for line in file]

    data = []
    
    for line in lines:
        spltline = line.split()
        if len(spltline) == 4:
            data.append(spltline[1:])

    return data

    


main()
