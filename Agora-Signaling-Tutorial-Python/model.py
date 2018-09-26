class DialogueRecord:

    def __init__(self, account, dialogue, time):
        self.acount = account
        self.dialogue = dialogue
        self.time = time

    def dr_to_dict(self):
        return {'account': self.acount, 'dialogue': self.dialogue, 'time': self.time}


class User:

    def __init__(self, session, account, uid):
        self.session = session
        self.account = account
        self.uid = uid
        self.channel = None
