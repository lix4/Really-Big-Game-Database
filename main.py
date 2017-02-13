# Use Python 2.7
# Make sure you install pyodbc and flask
# launch the server, then go to localhost:5000

import pyodbc
from flask import Flask, request, session, g, redirect, \
    url_for, abort, render_template, flash
from flask_login import login_user, logout_user, LoginManager, login_required
from forms import LoginForm, RegisterForm

conn = pyodbc.connect(
    'DRIVER={SQL Server};SERVER=titan.csse.rose-hulman.edu;DATABASE=ReallyBigGameDatabase;UID=lix4;PWD=cjlxw1h,.')
cursor = conn.cursor()
cursor.execute("SELECT * FROM Game")
rows = cursor.fetchall()

#---------------------IMPORTANT GLOBAL VARIABLE. DO NOT DELETE!!!!!-------
current_userID = None

#-------------------------------------------------------------------------
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
    form = LoginForm(request.form)
    if request.method == 'POST':
        if form.validate_on_submit():
            # TODO Fill in the parameter
            cursor.execute('EXEC login ' +
                           request.form['userName'] + request.form['passWord'])
            r = cursor.fetchall()
            if (r == 1):
                # TODO
                return redirect('/')
        else:
            error = 'Invalid username or password.'
    return render_template('login.html', form=form, error=error)


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
    cursor.execute(
        "DECLARE @results TABLE(g_id int NULL, m_id int NULL); EXEC recommendations 'kelleyld', 10, 1770; SELECT * FROM @results")
    return cursor.fetchall()


def search():
    if request.form['submit'] == 'searchGame':
        cursor.execute('EXEC searchGames \'' + request.form['search'] + '\'')
        return cursor.fetchall()

@app.route("/inside_post/", methods=['GET', 'POST'])
def post_handler():
    if (request.method == 'POST'):

        # cursor.execute('EXEC createReview ')
        redirect(url_for('/inside_post'))
    return render_template('inside_post.html')

if __name__ == "__main__":
    app.secret_key = 'MySuperSecretPassword'
    login_manager = LoginManager()
    login_manager.init_app(app)
    login_manager.login_view = 'login'
    app.run()
