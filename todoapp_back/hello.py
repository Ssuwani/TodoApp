from flask import Flask, request, jsonify

app = Flask(__name__)

todo_list = [
    {
        "id": 0,
        "name": "Todo App 만들기",
        "done": False
    },
    {
        "id": 1,
        "name": "깃 커밋하기",
        "done": True
    }
]

@app.route('/load', methods=['GET', 'POST'])
def load():
    return jsonify(todo_list)

@app.route('/add', methods=['GET', 'POST'])
def addTodo():
    new_task = dict()
    new_task["id"] = len(todo_list)
    if request.method == 'POST':
        task = request.data.decode('utf8')
        new_task["name"] = task
        new_task['done'] = False
        print(new_task)
        todo_list.append(new_task)
        return jsonify(todo_list)
    else:
        return print("error")

@app.route('/doneOrNot', methods=['GET', 'POST'])
def doneOrNot():
    if request.method == 'POST':
        index = request.data.decode('utf8')
        for todo in todo_list:
            if todo['id'] == int(index):
                if todo['done']:
                    todo['done'] = False
                    break
                else:
                    todo['done'] = True
                    break

        print(todo_list)
        return jsonify(todo_list)
    else:
        return print("error")

@app.route('/remove', methods=['GET', 'POST'])
def removeTodo():
    if request.method == 'POST':
        remove_index = request.data.decode('utf8')
        del todo_list[int(remove_index)]
        return jsonify(todo_list)
    else:
        return print("error")
if __name__ == '__main__':
    app.run(host='192.168.0.8')
