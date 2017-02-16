# Use Python 2.7
# Make sure you install pyodbc and flask
# launch the server, then go to localhost:5000

import sys
from flask import (Flask, abort, flash, g, redirect, render_template, request,
                   session, url_for)
from flask_login import LoginManager, login_required, login_user, logout_user, current_user

import pyodbc
from forms import LoginForm, RegisterForm

class User:
    __tablename__ = "Users"
    UName = ""
    Alias = ""

    def __init__(self, UName, Alias):
        self.UName = UName
        self.Alias = Alias

    def is_authenticated(self):
        return True

    def is_active(self):
        return True

    def is_anonymous(self):
        return False

    def get_id(self):
        return unicode(self.UName)

    def get_alias(self):
        return str(self.Alias)

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
    if (str(current_user.get_id()) == None):
        flash("You can not loged in!!!!!!!!!!")
    if (request.method == 'POST'):
        return render_template('show_entries.html', entries=search(), recommendations=showRecommendation())
    elif (request.method == 'GET'):
        rows = showInfo()
        return render_template('show_entries.html', entries=rows, recommendations=showRecommendation(), alias=current_user.get_alias())

@app.route("/update_alias/", methods=['GET', 'POST'])
def update_alias():
    if request.method == 'POST':
        new_alias = request.form['new_alias']
        cursor.execute("UPDATE Users SET alias='" + new_alias + "' WHERE Uname='" + current_user.get_id() + "'")
        main()
    cursor.execute("SELECT GName, Game_id FROM Likes, Game WHERE Likes.Game_id = Game.Game_id AND Uname = '" + str(current_user.get_id()) + "'")
    return render_template('update_alias.html', temp=current_user.get_alias(), likes=cursor.fetchall())

def showInfo():
    cursor.execute("SELECT TOP(20) * FROM Game")
    rows = cursor.fetchall()
    return rows

@app.route("/login/", methods=['GET', 'POST'])
def login():
    error = None
    # form = LoginForm(request.form)
    if request.method == 'POST':
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
        
        cursor.execute("SELECT Alias From Users where Uname = '" + UName + "'")
        temp_alias = cursor.fetchone()[0]
        users.append(User(UName, temp_alias))
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
    if request.method == 'POST':
        uname = request.form['username']
        sys.stdout.write(uname)
        password = request.form['password']
        alias = request.form['alias']
        sys.stdout.write(password)
        sys.stdout.write(alias)
        command = """SET NOCOUNT ON
        DECLARE @output VARCHAR(255)
                     EXEC registerUser '%s', '%s', '%s', @output OUTPUT
                     SELECT @output""" % (uname, password, alias)
        sys.stdout.write(command + "\n")
        sys.stdout.flush()
        cursor.execute(command)
        result = cursor.fetchall()
        sys.stdout.write(str(result))
        sys.stdout.flush()
        if (result == '1'):
            sys.stdout.write('Successfully created user.')
            sys.stdout.flush()
        else:
            sys.stdout.write('That username has already been used.')
            sys.stdout.flush()
    return render_template('register.html')


@app.route("/logout/", methods=['GET', 'POST'])
@login_required
def logout():
    logout_user()
    flash('You were logged out.')
    return redirect(url_for('home.welcome'))

def showRecommendation():
    # The hardcoded arguments are just for testing
    command = """SET NOCOUNT ON
                 DECLARE @ret TABLE (gid int, mid int)
                 INSERT INTO @ret EXEC recommendations '%s', 10, """ % (current_user.get_id())
    if request.method == 'POST' and 'submit' in request.form and request.form['submit'] == 'searchGame':
        sys.stdout.write('Found search key ' + request.form['search'])
        sys.stdout.flush()
        cursor.execute("EXEC searchGames'" + request.form['search'] + "'")
        command = command + str(cursor.fetchone().Game_id)
    else:
        command = command + '0'
    cursor.execute(command + """\nSELECT GName FROM @ret, Game WHERE Game_id = gid""")
    return cursor.fetchall()


@app.route("/inside_post/<Game_id>", methods=['GET', 'POST'])
def gameinfo(Game_id='0'):
    if (Game_id.isdigit()):
        cursor.execute("""SELECT * FROM Game WHERE Game_id = %s""" % Game_id)
    rows = cursor.fetchall()
    if (Game_id.isdigit()):
        cursor.execute("""SELECT * FROM Review WHERE Game_id = %s""" % Game_id)
    reviews = cursor.fetchall()
    if (Game_id.isdigit()):
        cursor.execute("""SELECT R_id from Review where Uname='%s' and Game_id=%s""" % (str(current_user.get_id()), Game_id))
    review_id = cursor.fetchone()
    if (review_id):
        review_id = review_id[0]
    else:
        review_id = 0
    if (request.method == 'POST'):
        if (request.form['submit'] == 'add'):
            uname = str(current_user.get_id())
            paragraph = request.form['paragraph']
            rating = request.form['rating']
            tag = request.form['tags']
            command = """SET NOCOUNT ON 
                         DECLARE @output VARCHAR(255);
                         EXEC createReview '%s', %s, %s, 0, '%s', '%s', @output OUTPUT;
                         SELECT @output;""" % (uname, rating, Game_id, paragraph, tag)
            cursor.execute(command)
        elif (request.form['submit'] == 'searchGame'):
            result = search()
            return render_template('show_entries.html', entries=result, recommendations=result, alias=current_user.get_alias())
        elif (request.form['submit'] == 'Delete'):
            command = """SET NOCOUNT ON
                         DECLARE @output VARCHAR(255)
                         EXEC deleteReview '%s', %s, 0, @output OUTPUT
                         SELECT * FROM @output""" % (str(current_user.get_id()), Game_id)
            sys.stdout.write(command + "\n")
            sys.stdout.flush()
            cursor.execute(command)
            r = cursor.fetchall()
            if (r[0] == 'Successfully deleted review.'):
                return render_template('inside_post.html', games=rows, comments=reviews, review_id=int(review_id), logged_in=(str(current_user.get_id()) != 'None'))
            elif (r == 'No legal review.'):
                flash('Fail to delete!!!!!!!!!!')
    #elif (request.method == 'GET'):
    return render_template('inside_post.html', games=rows, comments=reviews, review_id=int(review_id), logged_in=(str(current_user.get_id()) != 'None'))


def search():
    if request.form['submit'] == 'searchGame':
        cursor.execute('EXEC searchGames \'' + request.form['search'] + '\'')
        return cursor.fetchall()

if __name__ == "__main__":
    app.secret_key = 'MySuperSecretPassword'
    app.run()
