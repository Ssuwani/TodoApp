

todo_list = [
    # {
    #     "id": 0,
    #     "name": "Todo App 만들기",
    #     "done": False
    # },
    # {
    #     "id": 1,
    #     "name": "깃 커밋하기",
    #     "done": True
    # }
]


from flask import Flask, jsonify
from multiprocessing import Value

counter = Value('i', 0)
app = Flask(__name__)

@app.route('/')
def index():
    with counter.get_lock():
        counter.value += 1
        out = counter.value

    return jsonify(count=out)

app.run()
