// Saved registers for kernel context switches.
struct context {
  uint64 ra;
  uint64 sp;

  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

// Per-CPU state.
struct cpu {
  struct proc *proc;          // The process running on this cpu, or null.
  struct context context;     // swtch() here to enter scheduler().
  int noff;                   // Depth of push_off() nesting.
  int intena;                 // Were interrupts enabled before push_off()?
};

extern struct cpu cpus[NCPU];

// per-process data for the trap handling code in trampoline.S.
// sits in a page by itself just under the trampoline page in the
// user page table. not specially mapped in the kernel page table.
// the sscratch register points here.
// uservec in trampoline.S saves user registers in the trapframe,
// then initializes registers from the trapframe's
// kernel_sp, kernel_hartid, kernel_satp, and jumps to kernel_trap.
// usertrapret() and userret in trampoline.S set up
// the trapframe's kernel_*, restore user registers from the
// trapframe, switch to the user page table, and enter user space.
// the trapframe includes callee-saved user registers like s0-s11 because the
// return-to-user path via usertrapret() doesn't return through
// the entire kernel call stack.
struct trapframe {
  /*   0 */ uint64 kernel_satp;   // kernel page table
  /*   8 */ uint64 kernel_sp;     // top of process's kernel stack
  /*  16 */ uint64 kernel_trap;   // usertrap()
  /*  24 */ uint64 epc;           // saved user program counter
  /*  32 */ uint64 kernel_hartid; // saved kernel tp
  /*  40 */ uint64 ra;
  /*  48 */ uint64 sp;
  /*  56 */ uint64 gp;
  /*  64 */ uint64 tp;
  /*  72 */ uint64 t0;
  /*  80 */ uint64 t1;
  /*  88 */ uint64 t2;
  /*  96 */ uint64 s0;
  /* 104 */ uint64 s1;
  /* 112 */ uint64 a0;
  /* 120 */ uint64 a1;
  /* 128 */ uint64 a2;
  /* 136 */ uint64 a3;
  /* 144 */ uint64 a4;
  /* 152 */ uint64 a5;
  /* 160 */ uint64 a6;
  /* 168 */ uint64 a7;
  /* 176 */ uint64 s2;
  /* 184 */ uint64 s3;
  /* 192 */ uint64 s4;
  /* 200 */ uint64 s5;
  /* 208 */ uint64 s6;
  /* 216 */ uint64 s7;
  /* 224 */ uint64 s8;
  /* 232 */ uint64 s9;
  /* 240 */ uint64 s10;
  /* 248 */ uint64 s11;
  /* 256 */ uint64 t3;
  /* 264 */ uint64 t4;
  /* 272 */ uint64 t5;
  /* 280 */ uint64 t6;
};

enum procstate { UNUSED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
  struct spinlock lock;

  // p->lock must be held when using these:
  enum procstate state;        // Process state
  struct proc *parent;         // Parent process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  int xstate;                  // Exit status to be returned to parent's wait
  int pid;                     // Process ID

  // these are private to the process, so p->lock need not be held.
  uint64 kstack;               // Virtual address of kernel stack
  uint64 sz;                   // Size of process memory (bytes)
  pagetable_t pagetable;       // User page table
  struct trapframe *trapframe; // data page for trampoline.S
  struct context context;      // swtch() here to run process
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)


// EEE3535 Operating System
// Assignment #4 Scheduling
// Author: SukJoon Oh, 2018142216, acoustikue@yonsei.ac.kr
#define SUKJOON
#ifdef SUKJOON
  int           p_id;           // This p_id holds which queue it is located in.
  uint          p_ticks[3];     // ticks.
  uint          p_stp;          // tick calculation starting point
  struct proc*  p_prev;         // Maybe unnecessary?
  struct proc*  p_next;         // Move to the next element.

#endif
};


#ifdef SUKJOON
typedef struct __queue {
  int           q_id;           // Queue holds its ID. Q2 holds 2 for instance.
  int           q_cnt;          // Element counter.
  struct proc*  q_head;         // First element position.   
  struct proc*  q_tail;         // Last element position.
} _queue;

// Initializes struct __queue. 
// This function should be called when the system was on booting.
// procinit(), for instance. Any scope in front of scheduler() function will do.
void init_queue(_queue*, int);

//
// Process controls
int             is_q2(struct proc*);  // Is the element in q2?
int             is_q1(struct proc*);  // Is the element in q1?
int             is_q0(struct proc*);  // Is the element in q0?

int             color(struct proc*, int); // Mark the possession.
int             uncolor(struct proc*);    // Delete the mark.
int             ground(struct proc*);     // Make both arms zeros.
int             record_tick(struct proc*, int); 
int             record_tick2(struct proc*, uint);

//
// Queue controls
int             is_empty(_queue*);     // zero if not empty.

struct proc*    get_head(_queue*);     // returns __queue::q_head.
struct proc*    get_tail(_queue*);     // returns __queue::q_tail.
int             get_cnt(_queue*);      // returns __queue::q_cnt.

struct proc*    run_this(struct proc*);

struct proc*    enqueue(_queue*, struct proc*);
struct proc*    dequeue(_queue*);
struct proc*    remove(_queue*, struct proc*);

void            show_queue_status();
//
// New scheduler
// This will substitute the conventional scheduler().
// To make overall code structure unchanged, this function will be called in scheduler().
void            mlfq_like(void) __attribute__((noreturn));
// Original scheduler() does not return a thing. If any function called inside the scheduler(),
// It is best to make it noreturn, or the compiler will warn you.

#endif
