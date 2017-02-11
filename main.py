# Use Python 2.7
# Make sure you install pyodbc and flask
# launch the server, then go to localhost:5000

import pyodbc
from flask import Flask, request, session, g, redirect, \
    url_for, abort, render_template, flash
from flask_login import login_required

conn = pyodbc.connect('DRIVER={SQL Server};SERVER=titan.csse.rose-hulman.edu;DATABASE=ReallyBigGameDatabase;UID=lix4;PWD=cjlxw1h,.')
cursor=conn.cursor()
cursor.execute("SELECT * FROM Game")
rows = cursor.fetchall()
for row in rows:
    print row.GName

app = Flask(__name__)


@app.route("/", methods = ['GET', 'POST'])
def main():
    if (request.method == 'POST'):
        return render_template('show_entries.html', entries=search()), showRecommendation()
    elif (request.method == 'GET'):
        rows = showInfo()
        return render_template('show_entries.html', entries=rows, recommendations=rows)

def showInfo():
    cursor.execute("SELECT * FROM Game")
    rows = cursor.fetchall()
    return rows

@app.route("/login", methods=['GET'])
@login_required
def login():
    print("should print sth")
    # print(request.form['userName'])
    # print(request.form['passWord'])
    # cursor.execute("EXEC login " + request.form['userName'] + request.form['passWord'])
    # result = cursor.fetchall()
    # if (result == True):
    #     pass
    # else:
    #     pass
    return render_template('login.html')

def showRecommendation():
    cursor.execute()
    return cursor.fetchall()

def search():
    if request.form['submit'] == 'searchGame':
       cursor.execute('EXEC searchGames ' + request.form['search'])
       return cursor.fetchall()

if __name__ == "__main__":
    app.run()
