The flowchart of CPU mode transition

```mermaid
graph TD
	A[Start] -->|Bootup| B(Machine mode)
	B --> C(Kernel mode)
	C --> |Active| D[User mode]
	D --> |Interrupt| B
	D --> |Syscall| C
```
