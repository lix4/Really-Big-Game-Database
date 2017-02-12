# Use Python 2.7
# Make sure you install pyodbc and flask
# launch the server, then go to localhost:5000

import pyodbc
from flask import Flask, request, session, g, redirect, \
    url_for, abort, render_template, flash
from flask_login import LoginManager, login_required

conn = pyodbc.connect('DRIVER={SQL Server};SERVER=titan.csse.rose-hulman.edu;DATABASE=ReallyBigGameDatabase;UID=lix4;PWD=cjlxw1h,.')
cursor=conn.cursor()
cursor.execute("SELECT * FROM Game")
rows = cursor.fetchall()
# for row in rows:
#   print row.GName

app = Flask(__name__)



# Holds all the user objects for all users (ever?)
users = []

# Used for login management. Takes in the unicode ID of the user and
# return the object associated with it.
# @login_manager.user_loader
# def load_user(user_id):
#     for user in users:
#         if (user.get_id() == user_id):
#             return user
#     return None

@login_required
@app.route("/", methods = ['GET', 'POST'])
def main():
    if (request.method == 'POST'):
        return render_template('show_entries.html', entries=search())#, showRecommendation()
    elif (request.method == 'GET'):
        rows = showInfo()
        return render_template('show_entries.html', entries=rows, recommendations=rows)

def showInfo():
    cursor.execute("SELECT * FROM Game")
    rows = cursor.fetchall()
    return rows

@app.route("/login/", methods=['GET', 'POST'])
def login():
    # cursor.execute("EXEC login " + request.form['userName'] + request.form['passWord'])
    # result = cursor.fetchall()
    # if (result == True):
    #     print("Yay!")
    # else:
    #     print("Aww...")
    return render_template('login.html')

# TODO Help me I'm broken!
def showRecommendation():
    # The hardcoded arguments are just for testing
    cursor.execute("DECLARE @results TABLE(g_id int NULL, m_id int NULL); EXEC recommendations 'kelleyld', 10, 1770; SELECT * FROM @results")
    return cursor.fetchall()

def search():
    if request.form['submit'] == 'searchGame':
       cursor.execute('EXEC searchGames ' + request.form['search'])
       return cursor.fetchall()

if __name__ == "__main__":
    app.secret_key = 'MySuperSecretPassword'
    login_manager = LoginManager()
    login_manager.init_app(app)
    login_manager.login_view = 'login'
    app.run()
