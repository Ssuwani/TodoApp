

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

for todo in todo_list:
    if todo['id'] == 1:
        print(todo["name"])
