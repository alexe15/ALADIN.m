# Abstractify Aladin

__This document supports the discussion of an [important open issue for Aladin.](https://github.com/alexe15/ALADIN.m/issues/84) Please make sure to refer to this issue whenever you push commits to the repository.__

The goal is to untangle Casadi from ALADIN-M.
Why?
Because Casadi does not scale well to large problems, unfortunately.
The goal is to end up with two separate packages (the names are clearly just suggestions):
    
- AladinCore, and
- Casadi4Aladin.

## AladinCore

This is the core package that implements the Aladin algorithm itself.
Taking a look at [`run_ALADINnew.m`](https://github.com/alexe15/ALADIN.m/blob/abstractify/src/core/run_ALADINnew.m), then AladinCore would provide every functionality beginning with [`iterateAL()`](https://github.com/alexe15/ALADIN.m/blob/abstractify/src/core/iterateAL.m).
The essential (but *not* all) inputs the user needs to specify are

[![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGggTFI7XG4gICAgY29zdChDb3N0IGZ1bmN0aW9uKSAtLT4gY29zdF9jb2RlKGxvY0Z1bnMuZmZpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgZXEoRXF1YWxpdHkgY29uc3RyYWludHMpIC0tPiBlcV9jb2RlKGxvY0Z1bnMuZ2dpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgaW5lcShJbmVxdWFsaXR5IGNvbnN0cmFpbnRzKSAtLT4gaW5lcV9jb2RlKGxvY0Z1bnMuaGhpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgbG9jRnVucyhsb2NGdW5zKTo6OmNvZGUgLS0-IEFsYWRpbkNvcmUoQWxhZGluQ29yZSk7XG5cbiAgICBncmFkKEdyYWRpZW50KSAtLT4gZ3JhZF9jb2RlKHNlbnMuZ2cpOjo6Y29kZSAtLT4gc2VucztcbiAgICBqYWMoSmFjb2JpYW4pIC0tPiBqYWNfY29kZShzZW5zLkpKYWMpOjo6Y29kZSAtLT4gc2VucztcbiAgICBoZXNzKEhlc3NpYW4pIC0tPiBoZXNzX2NvZGUoc2Vucy5ISCk6Ojpjb2RlIC0tPiBzZW5zO1xuICAgIHNlbnMoc2Vucyk6Ojpjb2RlIC0tPiBBbGFkaW5Db3JlKEFsYWRpbkNvcmUpO1xuXG4gICAgbmxwKExvY2FsIE5MUCkgLS0-IHNvbHZlX25scF9jb2RlKHNvbHZlX25scCk6Ojpjb2RlIC0tPiBubmxwOjo6Y29kZSAtLT4gQWxhZGluQ29yZTtcbiAgICBubHAoTG9jYWwgTkxQKSAtLT4gcGFyc19jb2RlKHBhcnMpOjo6Y29kZSAtLT4gbm5scDo6OmNvZGU7XG5cbiAgICBBbGFkaW5Db3JlLS0-c29sdXRpb24oU29sdXRpb24pOjo6c29sdmVyO1xuXG4gICAgY2xhc3NEZWYgY29kZSBmaWxsOiNiYmJiYmIsIGZvbnQtZmFtaWx5OiBNZW5sbywgTW9uYWNvLCBzYW5zLXNlcmlmLCBmb250LXNpemU6MTBweDtcbiAgICBjbGFzc0RlZiBzb2x2ZXIgZmlsbDojRkZBQTMzOyIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZ3JhcGggTFI7XG4gICAgY29zdChDb3N0IGZ1bmN0aW9uKSAtLT4gY29zdF9jb2RlKGxvY0Z1bnMuZmZpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgZXEoRXF1YWxpdHkgY29uc3RyYWludHMpIC0tPiBlcV9jb2RlKGxvY0Z1bnMuZ2dpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgaW5lcShJbmVxdWFsaXR5IGNvbnN0cmFpbnRzKSAtLT4gaW5lcV9jb2RlKGxvY0Z1bnMuaGhpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgbG9jRnVucyhsb2NGdW5zKTo6OmNvZGUgLS0-IEFsYWRpbkNvcmUoQWxhZGluQ29yZSk7XG5cbiAgICBncmFkKEdyYWRpZW50KSAtLT4gZ3JhZF9jb2RlKHNlbnMuZ2cpOjo6Y29kZSAtLT4gc2VucztcbiAgICBqYWMoSmFjb2JpYW4pIC0tPiBqYWNfY29kZShzZW5zLkpKYWMpOjo6Y29kZSAtLT4gc2VucztcbiAgICBoZXNzKEhlc3NpYW4pIC0tPiBoZXNzX2NvZGUoc2Vucy5ISCk6Ojpjb2RlIC0tPiBzZW5zO1xuICAgIHNlbnMoc2Vucyk6Ojpjb2RlIC0tPiBBbGFkaW5Db3JlKEFsYWRpbkNvcmUpO1xuXG4gICAgbmxwKExvY2FsIE5MUCkgLS0-IHNvbHZlX25scF9jb2RlKHNvbHZlX25scCk6Ojpjb2RlIC0tPiBubmxwOjo6Y29kZSAtLT4gQWxhZGluQ29yZTtcbiAgICBubHAoTG9jYWwgTkxQKSAtLT4gcGFyc19jb2RlKHBhcnMpOjo6Y29kZSAtLT4gbm5scDo6OmNvZGU7XG5cbiAgICBBbGFkaW5Db3JlLS0-c29sdXRpb24oU29sdXRpb24pOjo6c29sdmVyO1xuXG4gICAgY2xhc3NEZWYgY29kZSBmaWxsOiNiYmJiYmIsIGZvbnQtZmFtaWx5OiBNZW5sbywgTW9uYWNvLCBzYW5zLXNlcmlmLCBmb250LXNpemU6MTBweDtcbiAgICBjbGFzc0RlZiBzb2x2ZXIgZmlsbDojRkZBQTMzOyIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)

The setting up of the local NLPs is part of AladinCore, hence all supported solvers should be declared in [`createLocalSolvers()`](https://github.com/alexe15/ALADIN.m/blob/abstractify/src/core/createLocalSolvers.m).
Currently, there are implementations for

- Ipopt & Casadi,  and
- `fmincon`.


The remaining entries from `sProb` required to run `iterateAL()` are needed mostly for constraint handling and initial conditions.

The entries
```matlab
    sProb.locFunsCas: [1×1 struct]
    sProb.xxCas: {[474×1 casadi.SX]  [478×1 casadi.SX]  [476×1 casadi.SX]}
    sProb.rhoCas: [1×1 casadi.SX]
```
should not be required whatsoever!


### Status 

There is a prototypical working implementation to solve a distributed power flow problem with fmincon and user-supplied sensitivities.
__However, the implementation is tailored to a very specific problem class and has not been tested for anything else.__
For this to work, check out/get access [to this repository](https://iai-vcs.iai.kit.edu/advancedcontrol/code/morenet/morenet) (make sure to check out its [documentation](http://iai-webserv.iai.kit.edu/morenet) to get started), which can be used together with [Aladin's `abstractify` branch](https://github.com/alexe15/ALADIN.m/tree/abstractify).
Run [this test file](https://iai-vcs.iai.kit.edu/advancedcontrol/code/morenet/morenet/-/blob/master/00_use-case/test_file.m) both for `use_fmincon = true` and `use_fmincon = false`. The former uses fmincon and user-supplied sensitivities, while the latter uses Ipopt and casadi.
To get a better feeling, play with a small test system such as 

```matlab
%% setup
fields_to_merge = {'bus', 'gen', 'branch'};
mpc_master  = loadcase('case14');
mpc_slaves = { loadcase('case30')
             loadcase('case9')  };

connection_array = [2 1 1 2;
                    2 3 2 3; 
                    2 3 13 1;
                    ];
```

## Casadi4Aladin

Casadi4Aladin frees the user from having to specify sensitivities.
Instead, these sensitivities will be computed using Casadi.
It's function is something like this

[![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGggTFI7XG4gICAgY29zdChDb3N0IGZ1bmN0aW9uKSAtLT4gY29zdF9jb2RlKGxvY0Z1bnMuZmZpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgZXEoRXF1YWxpdHkgY29uc3RyYWludHMpIC0tPiBlcV9jb2RlKGxvY0Z1bnMuZ2dpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgaW5lcShJbmVxdWFsaXR5IGNvbnN0cmFpbnRzKSAtLT4gaW5lcV9jb2RlKGxvY0Z1bnMuaGhpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgbG9jRnVucyhsb2NGdW5zKTo6OmNvZGUgLS0-IGNhczRhbChDYXNhZGk0QWxhZGluKTtcblxuICAgIGNhczRhbCAtLT4gc2VucyAtLT4gZ3JhZF9jb2RlKHNlbnMuZ2cpOjo6Y29kZSAtLT4gZ3JhZChHcmFkaWVudCk7XG4gICAgc2VucyAtLT4gamFjX2NvZGUoc2Vucy5KSmFjKTo6OmNvZGUgLS0-IGphYyhKYWNvYmlhbik7XG4gICAgc2VucyAtLT4gaGVzc19jb2RlKHNlbnMuSEgpOjo6Y29kZSAtLT4gaGVzcyhIZXNzaWFuKTtcbiAgICBzZW5zKHNlbnMpOjo6Y29kZSBcblxuICAgIGNhczRhbCAtLT4gbm5scDo6OmNvZGUgLS0-IHNvbHZlX25scF9jb2RlKHNvbHZlX25scCk6Ojpjb2RlIC0tPiBubHAoTG9jYWwgTkxQKTtcbiAgICBubmxwOjo6Y29kZSAtLT4gcGFyc19jb2RlKHBhcnMpOjo6Y29kZSAtLT4gbmxwKExvY2FsIE5MUCk7XG5cbiAgICBjYXM0YWwgLS0-IGxvY0Z1bnNDYXM6Ojpjb2RlO1xuICAgIGNhczRhbCAtLT4geHhDYXM6Ojpjb2RlO1xuICAgIGNhczRhbCAtLT4gcmhvQ2FzOjo6Y29kZTtcblxuICAgIGNsYXNzRGVmIGNvZGUgZmlsbDojYmJiYmJiLCBmb250LWZhbWlseTogTWVubG8sIE1vbmFjbywgc2Fucy1zZXJpZiwgZm9udC1zaXplOjEwcHg7XG4gICAgY2xhc3NEZWYgc29sdmVyIGZpbGw6I0ZGQUEzMzsiLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZ3JhcGggTFI7XG4gICAgY29zdChDb3N0IGZ1bmN0aW9uKSAtLT4gY29zdF9jb2RlKGxvY0Z1bnMuZmZpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgZXEoRXF1YWxpdHkgY29uc3RyYWludHMpIC0tPiBlcV9jb2RlKGxvY0Z1bnMuZ2dpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgaW5lcShJbmVxdWFsaXR5IGNvbnN0cmFpbnRzKSAtLT4gaW5lcV9jb2RlKGxvY0Z1bnMuaGhpKTo6OmNvZGUgLS0-IGxvY0Z1bnM7XG4gICAgbG9jRnVucyhsb2NGdW5zKTo6OmNvZGUgLS0-IGNhczRhbChDYXNhZGk0QWxhZGluKTtcblxuICAgIGNhczRhbCAtLT4gc2VucyAtLT4gZ3JhZF9jb2RlKHNlbnMuZ2cpOjo6Y29kZSAtLT4gZ3JhZChHcmFkaWVudCk7XG4gICAgc2VucyAtLT4gamFjX2NvZGUoc2Vucy5KSmFjKTo6OmNvZGUgLS0-IGphYyhKYWNvYmlhbik7XG4gICAgc2VucyAtLT4gaGVzc19jb2RlKHNlbnMuSEgpOjo6Y29kZSAtLT4gaGVzcyhIZXNzaWFuKTtcbiAgICBzZW5zKHNlbnMpOjo6Y29kZSBcblxuICAgIGNhczRhbCAtLT4gbm5scDo6OmNvZGUgLS0-IHNvbHZlX25scF9jb2RlKHNvbHZlX25scCk6Ojpjb2RlIC0tPiBubHAoTG9jYWwgTkxQKTtcbiAgICBubmxwOjo6Y29kZSAtLT4gcGFyc19jb2RlKHBhcnMpOjo6Y29kZSAtLT4gbmxwKExvY2FsIE5MUCk7XG5cbiAgICBjYXM0YWwgLS0-IGxvY0Z1bnNDYXM6Ojpjb2RlO1xuICAgIGNhczRhbCAtLT4geHhDYXM6Ojpjb2RlO1xuICAgIGNhczRhbCAtLT4gcmhvQ2FzOjo6Y29kZTtcblxuICAgIGNsYXNzRGVmIGNvZGUgZmlsbDojYmJiYmJiLCBmb250LWZhbWlseTogTWVubG8sIE1vbmFjbywgc2Fucy1zZXJpZiwgZm9udC1zaXplOjEwcHg7XG4gICAgY2xhc3NEZWYgc29sdmVyIGZpbGw6I0ZGQUEzMzsiLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)
