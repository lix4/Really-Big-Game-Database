# Use Python 2.7
# Make sure you install pyodbc and flask
# launch the server, then go to localhost:5000

import pyodbc
from flask import Flask, request, session, g, redirect, \
    url_for, abort, render_template, flash

conn = pyodbc.connect('DRIVER={SQL Server};SERVER=titan.csse.rose-hulman.edu;DATABASE=ReallyBigGameDatabase;UID=kelleyld;PWD=USE_YOUR_OWN!');
cursor=conn.cursor()
cursor.execute("SELECT * FROM Game")
rows = cursor.fetchall()
for row in rows:
    print row.GName

app = Flask(__name__)


@app.route("/")
def hello():
    cursor.execute("SELECT * FROM Game")
    rows = cursor.fetchall()
    return render_template('show_entries.html', entries=rows)

@app.route("/test/")
def test():
    return "Hello world"

if __name__ == "__main__":
    app.run()
