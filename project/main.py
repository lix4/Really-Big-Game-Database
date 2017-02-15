# Use Python 2.7
# Make sure you install pyodbc and flask
# launch the server, then go to localhost:5000

import sys
from flask import (Flask, abort, flash, g, redirect, render_template, request,
                   session, url_for)
from flask_login import LoginManager, login_required, login_user, logout_user

import pyodbc
from forms import LoginForm, RegisterForm

class User:
    __tablename__ = "Users"
    UName = ""

    def __init__(self, UName):
        self.UName = UName

    def is_authenticated(self):
        return True

    def is_active(self):
        return True

    def is_anonymous(self):
        return False

    def get_id(self):
        return unicode(self.UName)

conn = pyodbc.connect(
    'DRIVER={SQL Server};SERVER=titan.csse.rose-hulman.edu;DATABASE=ReallyBigGameDatabase;UID=lix4;PWD=cjlxw1h,.')  # replace your own id and password
cursor = conn.cursor()
cursor.execute("SELECT * FROM Game")
rows = cursor.fetchall()

app = Flask(__name__)

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'
#---------------------IMPORTANT GLOBAL VARIABLE. DO NOT DELETE!!!!!-------

#-------------------------------------------------------------------------
# for row in rows:
#   print row.GName


# Holds all the user objects for all users (ever?)
users = []

# Used for login management. Takes in the unicode ID of the user and
# return the object associated with it.
@login_manager.user_loader
def load_user(user_id):
    for one_user in users:
        if unicode(one_user.get_id()) == user_id:
            return one_user
    return None

@login_required
@app.route("/", methods=['GET', 'POST'])
def main():
    if (request.method == 'POST'):
        #, showRecommendation()
        return render_template('show_entries.html', entries=search())
    elif (request.method == 'GET'):
        rows = showInfo()
        return render_template('show_entries.html', entries=rows, recommendations=rows)


def showInfo():
    cursor.execute("SELECT TOP(20) * FROM Game")
    rows = cursor.fetchall()
    return rows

@app.route("/login/", methods=['GET', 'POST'])
def login():
    error = None
    # form = LoginForm(request.form)
    if request.method == 'POST':
#        if form.validate_on_submit():
        UName = request.form['username']
        Password = request.form['password']
        command = """DECLARE @valid smallint
                     EXEC login '%s', '%s', @valid OUTPUT
                     SELECT @valid""" % (UName, Password)
        cursor.execute(command)
        r = cursor.fetchall()
        sys.stdout.write("r = " + str(r[0][0]))
        sys.stdout.flush()
        if r[0][0] != 1:
            flash('Username or Password is invalid', 'error')
            return redirect(url_for('login'))

        users.append(User(UName))
        login_user(users[-1])
        flash('Successfully logged in')
        return redirect(request.args.get('next') or url_for('main'))
            # TODO Fill in the parameter
            
            # if (r == 1):
                # TODO
                # return redirect('/')
 #       else:
  #          error = 'Invalid username or password.'
    return render_template('login.html')


@app.route("/register/", methods=['GET', 'POST'])
def register():
    form = RegisterForm()
    if form.validate_on_submit():
        # register the user into database
        print(form.username.data)
        print(form.email.data)
        print(form.password.data)
        # cursor.execute('EXEC registerUser'+ request.form[''] + request.formp[]+request.form[])
        # r = cursor.fetchall()
        # if (r == 'Successfully created user')
        # return redirect('/')
    return render_template('register.html', form=form)


@app.route("/logout/", methods=['GET', 'POST'])
@login_required
def logout():
    # logout_user()
    flash('You were logged out.')
    return redirect(url_for('home.welcome'))

# TODO Help me I'm broken!
def showRecommendation():
    # The hardcoded arguments are just for testing
    cursor.execute("""DECLARE @ret TABLE(gid int, mid int)
                      INSERT INTO @ret EXEC recommendations 'kelleyld', 10, 1770
                      SELECT @ret""")
    return cursor.fetchall()


@app.route("/inside_post/<Game_id>", methods=['GET', 'POST'])
def gameinfo(Game_id=0):
    if (request.method == 'POST'):
        # Hard code uname "Smith"
        if (request.form['submit'] == 'add'):
            uname = flask_login.current_user.get_id()
            paragraph = request.form['paragraph']
            rating = request.form['rating']
            tag = request.form['tags']
            command = """DECLARE @output VARCHAR(255)
                         EXEC createReview '%s', %d, %d, 0, '%s', '%s', @output OUTPUT""" % uname, rating, Game_id, paragraph, tag
            cursor.execute(command)
        elif (request.form['submit'] == 'searchGame'):
            result = search()
            return render_template('show_entries.html', entries=result, recommendations=result)
    #elif (request.method == 'GET'):
    if (Game_id.isdigit()):
        cursor.execute("""SELECT * FROM Game WHERE Game_id = %s""" % Game_id)
    rows = cursor.fetchall()
    if (Game_id.isdigit()):
        cursor.execute("""SELECT * FROM Review WHERE Game_id = %s""" % Game_id)
    reviews = cursor.fetchall()
    return render_template('inside_post.html', games=rows, comments=reviews)


def search():
    if request.form['submit'] == 'searchGame':
        cursor.execute('EXEC searchGames \'' + request.form['search'] + '\'')
        return cursor.fetchall()

if __name__ == "__main__":
    app.secret_key = 'MySuperSecretPassword'
    app.run()
