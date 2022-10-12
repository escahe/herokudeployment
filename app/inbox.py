from flask import (
    Blueprint, flash, g, redirect, render_template, request, url_for, current_app, send_file
)

from app.auth import login_required
from app.db import get_db

bp = Blueprint('inbox', __name__, url_prefix='/inbox')

"""@bp.route("/getDB")
@login_required
def getDB():
    return send_file(current_app.config['DATABASE'], as_attachment=True)"""

@bp.route('/show')
@login_required
def show():
    db = get_db()
    query = f'SELECT subject, username, created, body FROM message JOIN user ON from_id = user.id WHERE to_id = {g.user["id"]};'
    query = query.split(";",1)[0]+";"
    messages = db.execute(
        query
    ).fetchall()

    return render_template('/inbox/show.html', messages=messages)

@bp.route('/send', methods=('GET', 'POST'))
@login_required
def send():
    if request.method == 'POST':
        from_id = g.user['id']
        to_username = request.form['to']
        subject = request.form['subject']
        body = request.form['body']
       
        if not to_username:
            flash('To field is required')
            return render_template('/inbox/show.html')
        
        if not subject:
            flash('Subject field is required')
            return render_template('inbox/send.html')
        
        if not body:
            flash('Body field is required')
            return render_template('/inbox/show.html')    
        
        error = None    
        userto = None

        db = get_db()
        query = f"SELECT * FROM user WHERE username = '{to_username}';"
        query = query.split(";",1)[0]+";"
        userto = db.execute(
            query
        ).fetchone()
        
        if userto is None:
            error = 'Recipient does not exist'
     
        if error:
            flash(error)
        else:
            db = get_db()
            query = f"INSERT INTO message (from_id,to_id,subject,body) VALUES('{g.user['id']}', '{userto['id']}', '{subject}', '{body}');"
            query = query.split(";",1)[0]+";"
            db.execute(
                query
            )
            db.commit()

            return redirect(url_for('inbox.show'))

    return render_template('inbox/send.html')