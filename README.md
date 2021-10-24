# stask

Simple Task format, includes a read/write library and a CLI pretty printer (as a client)

Licensed under the zlib license (each file separately, included at the top of each one)

## The format

Simple example, the **tasks.st** file included on this repo

```
[x] Task completed
	key: "value"

[-] Task in progress

[w] Task on hold

[ ] Task not done

[-] Do english homework
	due: "in three days"
	link: "example.com"

[ ] Buy a coffee

[-] Star Bowuigi/stask on GitHub
	priority : "A"
	link     : "https://github.com/Bowuigi/stask"
```

As you can see, a task is composed of three things:

+ Status (`[x]` completed, `[-]` in progress, `[w]` on hold, `[ ]` not done), indicated by the first three characters of the task name
+ Task, which is the rest of the line (not counting the space between this and the status)
+ Data in `key : "value"` and/or `key = value` format, allowing you to create things like due dates, priorities, descriptions, links, etc.

All of this organized like in this next example

```
[status] task
	data_key : "data_value"
	data_key2 : "data_value2"
	data_key3 : "data_value3"
```

## Documentation

Documentation for stask-lib is found on the file **stask-lib-docs.md**

The stask clients uses **tasks.st** or the first argument as the name of the file to read, the format is documented above
