from flask import Flask, request, session, g, redirect, \
    url_for, abort, render_template, flash, Blueprint

users_blueprint = Blueprint(
    'users', __name__,
    template_folder = 'template'
)

@users_blueprint.route("/insidepost/", methods=['GET', 'POST'])
def post_handler():
    if (request.method == 'POST'):
        paragraph = request.form['paragraph']
        rating = request.form['rating']
        # cursor.execute('EXEC createReview '+ + + rating + ++ paragraph)
        redirect(url_for('/insidepost'))
    return render_template('insidepost.html')