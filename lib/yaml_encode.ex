defmodule YamlEncode do
  @doc """
  Function that converts a map to a Yaml document

  ```
  iex> YamlEncode.encode(%{"test" => ["oke", 2]})
  {
    :ok,
    \"\"\"
    ---
    test:
      - oke
      - 2\\
    \"\"\"
  }
  ```

  Larger Example (ansible) for more examples check [the tests](#{Mix.Project.config()[:source_url]}/blob/master/test/yaml_encode_test.exs)

  ```
  maps = [
    %{
      "hosts" => "localhost",
      "tasks" => [
        %{"debug" => %{"msg" => "Testing a binary module written in Rust"}},
        %{"debug" => %{"var" => "ansible_system"}},
        %{"name" => "ping", "ping" => nil},
        %{
          "action" => "rust_helloworld",
          "name" => "Hello, World!",
          "register" => "hello_world"
        },
        %{"assert" => %{"that" => ["hello_world.msg == \"Hello, World!\"\n"]}},
        %{
          "action" => "rust_helloworld",
          "args" => %{"name" => "Ansible"},
          "name" => "Hello, Ansible!",
          "register" => "hello_ansible"
        },
        %{"assert" => %{"that" => ["hello_ansible.msg == \"Hello, Ansible!\"\n"]}},
        %{
          "action" => "rust_helloworld",
          "async" => 10,
          "name" => "Async Hello, World!",
          "poll" => 1,
          "register" => "async_hello_world"
        },
        %{
          "assert" => %{
            "that" => ["async_hello_world.msg == \"Hello, World!\"\n"]
          }
        },
        %{
          "action" => "rust_helloworld",
          "args" => %{"name" => "Ansible"},
          "async" => 10,
          "name" => "Async Hello, Ansible!",
          "poll" => 1,
          "register" => "async_hello_ansible"
        },
        %{
          "assert" => %{
            "that" => ["async_hello_ansible.msg == \"Hello, Ansible!\"\n"]
          }
        }
      ]
    }
  ]

  expected = \"\"\"
  ---
  hosts: localhost
  tasks:
    - debug:
        msg: Testing a binary module written in Rust
    - debug:
        var: ansible_system
    - name: ping
      ping: null
    - action: rust_helloworld
      name: "Hello, World!"
      register: hello_world
    - assert:
        that:
          - "hello_world.msg == "Hello, World!"
  "
    - action: rust_helloworld
      args:
        name: Ansible
      name: "Hello, Ansible!"
      register: hello_ansible
    - assert:
        that:
          - "hello_ansible.msg == "Hello, Ansible!"
  "
    - action: rust_helloworld
      async: 10
      name: "Async Hello, World!"
      poll: 1
      register: async_hello_world
    - assert:
        that:
          - "async_hello_world.msg == "Hello, World!"
  "
    - action: rust_helloworld
      args:
        name: Ansible
      async: 10
      name: "Async Hello, Ansible!"
      poll: 1
      register: async_hello_ansible
    - assert:
        that:
          - "async_hello_ansible.msg == "Hello, Ansible!"
  "\\
  \"\"\"
  ```

  """
  @spec encode(map | [map]) :: {:ok, binary} | {:error, binary}
  defdelegate encode(map), to: YamlEncode.Encoder
end
