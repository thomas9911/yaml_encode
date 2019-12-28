defmodule YamlEncodeTest do
  use ExUnit.Case

  test "empty map" do
    assert {:ok, "---\n"} == YamlEncode.encode(%{})
  end

  test "simple map" do
    map = %{"ok" => "test"}
    assert {:ok, "---\nok: test"} == YamlEncode.encode(map)
  end

  test "longer map" do
    map = %{"ok" => "test", "123" => "test", " 345" => "test", "a_list" => [1, 2, 3, 4]}

    assert {:ok,
            """
            ---
            " 345": test
            "123": test
            a_list:
              - 1
              - 2
              - 3
              - 4
            ok: test\
            """} ==
             YamlEncode.encode(map)
  end

  test "nested map" do
    map = %{
      "ok" => "test",
      "123" => %{
        "testing" => %{
          "nested" => 15
        },
        "list" => [1, 2, 3, 4]
      },
      " 345" => "test",
      "a_list" => [1, 2, 3, 4]
    }

    assert {:ok,
            """
            ---
            " 345": test
            "123":
              list:
                - 1
                - 2
                - 3
                - 4
              testing:
                nested: 15
            a_list:
              - 1
              - 2
              - 3
              - 4
            ok: test\
            """} ==
             YamlEncode.encode(map)
  end

  test "list of maps" do
    maps = [
      %{"test" => [1, 2, 3, 4]},
      %{"testing" => "test"}
    ]

    assert {:ok,
            """
            ---
            test:
              - 1
              - 2
              - 3
              - 4
            ---
            testing: test\
            """} ==
             YamlEncode.encode(maps)
  end

  test "invalid yaml" do
    map = %{
      "function" => fn -> nil end
    }

    assert {:error, _e} = YamlEncode.encode(map)
  end

  test "invalid yamls" do
    maps = [
      %{
        "function" => fn -> nil end
      },
      %{
        "function" => fn -> nil end
      }
    ]

    assert {:error, _e} = YamlEncode.encode(maps)
  end

  test "real world, random json" do
    map = %{
      "_id" => "5e077e7f669d76b1422aff45",
      "about" =>
        "Minim eu veniam in fugiat dolor officia velit sunt est quis amet ipsum. Et ea ex incididunt cillum laboris veniam cillum sit et commodo consequat aliqua laborum consequat. Nostrud aute sunt non irure laboris id aute aliquip voluptate nulla laboris do. Velit id occaecat elit minim occaecat ipsum amet elit est minim. Nostrud nisi incididunt minim excepteur laborum Lorem labore excepteur enim commodo. Dolore sunt laboris esse amet fugiat. Et non laboris labore fugiat.",
      "address" => "561 Java Street, Edgar, North Carolina, 7896",
      "age" => 40,
      "balance" => "$2,236.06",
      "company" => "PARCOE",
      "email" => "clarkbarnett@parcoe.com",
      "eyeColor" => "brown",
      "favoriteFruit" => "apple",
      "friends" => [
        %{"id" => 0, "name" => "Kelly Young"},
        %{"id" => 1, "name" => "Miles Roman"},
        %{"id" => 2, "name" => "Kirby Boone"}
      ],
      "gender" => "male",
      "greeting" => "Hello, Clark Barnett! You have 3 unread messages.",
      "guid" => "e330d9b7-a5a5-4d63-a062-c66ca5d1964f",
      "index" => 76,
      "isActive" => true,
      "latitude" => -13.725675,
      "longitude" => 96.225709,
      "name" => "Clark Barnett",
      "phone" => "+1 (950) 587-2562",
      "picture" => "http://placehold.it/32x32",
      "registered" => "2016-08-17T09:13:57 -02:00",
      "tags" => ["magna", "anim", "ad", "ea", "quis", "magna", "incididunt"]
    }

    assert {:ok,
            """
            ---
            _id: 5e077e7f669d76b1422aff45
            about: Minim eu veniam in fugiat dolor officia velit sunt est quis amet ipsum. Et ea ex incididunt cillum laboris veniam cillum sit et commodo consequat aliqua laborum consequat. Nostrud aute sunt non irure laboris id aute aliquip voluptate nulla laboris do. Velit id occaecat elit minim occaecat ipsum amet elit est minim. Nostrud nisi incididunt minim excepteur laborum Lorem labore excepteur enim commodo. Dolore sunt laboris esse amet fugiat. Et non laboris labore fugiat.
            address: "561 Java Street, Edgar, North Carolina, 7896"
            age: 40
            balance: "$2,236.06"
            company: PARCOE
            email: clarkbarnett@parcoe.com
            eyeColor: brown
            favoriteFruit: apple
            friends:
              - id: 0
                name: Kelly Young
              - id: 1
                name: Miles Roman
              - id: 2
                name: Kirby Boone
            gender: male
            greeting: "Hello, Clark Barnett! You have 3 unread messages."
            guid: e330d9b7-a5a5-4d63-a062-c66ca5d1964f
            index: 76
            isActive: true
            latitude: -13.725675
            longitude: 96.225709
            name: Clark Barnett
            phone: +1 (950) 587-2562
            picture: "http://placehold.it/32x32"
            registered: "2016-08-17T09:13:57 -02:00"
            tags:
              - magna
              - anim
              - ad
              - ea
              - quis
              - magna
              - incididunt\
            """} == YamlEncode.encode(map)
  end

  test "real world, kubernetes" do
    map = %{
      "apiVersion" => "apps/v1",
      "kind" => "Deployment",
      "metadata" => %{
        "name" => "nginx-deployment",
        "labels" => %{"app" => "nginx"}
      },
      "spec" => %{
        "replicas" => 3,
        "selector" => %{"matchLabels" => %{"app" => "nginx"}},
        "template" => %{
          "metadata" => %{"labels" => %{"app" => "nginx"}},
          "spec" => %{
            "containers" => [
              %{
                "image" => "nginx:1.7.9",
                "name" => "nginx",
                "ports" => [%{"containerPort" => 80}]
              }
            ]
          }
        }
      }
    }

    expected = """
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: nginx
      name: nginx-deployment
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
            - image: "nginx:1.7.9"
              name: nginx
              ports:
                - containerPort: 80\
    """

    assert {:ok, expected} == YamlEncode.encode(map)
  end
end
