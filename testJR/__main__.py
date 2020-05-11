import sys
import matplotlib
import matplotlib.pyplot as plt
matplotlib.use('Qt5Agg')

from PyQt5 import QtCore, QtWidgets

from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg
from matplotlib.figure import Figure

import testJR

class MplCanvas(FigureCanvasQTAgg):

    def __init__(self, parent=None, width=6, height=6, dpi=100):
        fig = Figure(figsize=(width, height), dpi=dpi)
        self.ax1 = fig.add_subplot(211)
        self.ax2 = fig.add_subplot(212)
        super(MplCanvas, self).__init__(fig)


class MainWindow(QtWidgets.QMainWindow):

    def __init__(self, *args, **kwargs):
        super(MainWindow, self).__init__(*args, **kwargs)

        # Create the maptlotlib FigureCanvas object, 
        # which defines a single set of axes as self.axes.
        #sc = MplCanvas(self, width=5, height=4, dpi=200)
        sc = MplCanvas(self, dpi=100)
        # first plot
        sc.ax1.plot([0,1,2,3,4], [10,1,20,3,40])
        sc.ax1.set_xlabel('time')
        sc.ax1.set_ylabel('life')
        # second plot
        sc.ax2.plot([10,1,20,3,40], [0,1,2,3,4], 'ro')
        sc.ax2.set_xlabel('life')
        sc.ax2.set_ylabel('time')

        # Get version
        verdata = testJR._version.get_versions()
        self.ver = verdata['version'].split('+')[0]
        self.date = verdata['date'].split('T')[0]
        self.build = verdata['version']
        self.setWindowTitle('test v'+ self.ver + ' ' + self.date)

        tb = QtWidgets.QToolBar()
        self.aboutaction = tb.addAction('About')
        self.addToolBar(tb)
        self.aboutaction.triggered.connect(self.about)

        self.setCentralWidget(sc)
        self.show()

    def about(self):
        QtWidgets.QMessageBox.information(self, 'About test',
                                'test v' + self.ver + ' ' + self.date + '\nBUILD: ' + self.build)

def main():
    plt.xkcd()
    app = QtWidgets.QApplication(sys.argv)
    w = MainWindow()
    app.exec_()

if __name__ == '__main__':
    main()
