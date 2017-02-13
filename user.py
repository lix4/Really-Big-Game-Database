class User(UserMixin):
    def __init__(self, uname):
        self.uname = uname
    
    # Return True if this user is authenticated
    @property
    def is_authenticated(self):
        return True # We may want to add logic here

    #Return True if this is an active user (i.e. not banned)
    @property
    def is_active(self):
        return True

    #Return True if this is an anonymous user
    @property
    def is_anonymous(self):
        return False

    #Return the uniced ID that uniquely identifies this user and can
    #be used to load this user from the user_loader callback
    def get_id(self):
        return self.uname
