import sys
import matplotlib
import matplotlib.pyplot as plt
matplotlib.use('Qt5Agg')

from PyQt5 import QtCore, QtWidgets

from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg
from matplotlib.figure import Figure


class MplCanvas(FigureCanvasQTAgg):

    def __init__(self, parent=None, width=6, height=6, dpi=100):
        fig = Figure(figsize=(width, height), dpi=dpi)
        self.axes = fig.add_subplot(111)
        super(MplCanvas, self).__init__(fig)


class MainWindow(QtWidgets.QMainWindow):

    def __init__(self, *args, **kwargs):
        super(MainWindow, self).__init__(*args, **kwargs)

        # Create the maptlotlib FigureCanvas object, 
        # which defines a single set of axes as self.axes.
        #sc = MplCanvas(self, width=5, height=4, dpi=200)
        sc = MplCanvas(self, dpi=100)
        sc.axes.plot([0,1,2,3,4], [10,1,20,3,40])
        sc.axes.set_xlabel('time')
        sc.axes.set_ylabel('life')

        self.setCentralWidget(sc)

        self.show()


def main():
    plt.xkcd()
    app = QtWidgets.QApplication(sys.argv)
    w = MainWindow()
    app.exec_()

if __name__ == '__main__':
    main()
