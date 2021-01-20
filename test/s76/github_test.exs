defmodule S76.GithubTest do
  use S76.DataCase

  alias S76.Github

  describe "repositories" do
    alias S76.Github.Repository

    @valid_attrs %{name: "some name", owner: "some owner"}
    @update_attrs %{
      name: "some updated name",
      owner: "some updated owner"
    }
    @invalid_attrs %{name: nil, owner: nil}

    def repository_fixture(attrs \\ %{}) do
      {:ok, repository} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Github.create_repository()

      repository
    end

    test "list_repositories/0 returns all repositories" do
      repository = repository_fixture()
      assert Github.list_repositories() == [repository]
    end

    test "get_repository!/1 returns the repository with given id" do
      repository = repository_fixture()
      assert Github.get_repository!(repository.id) == repository
    end

    test "create_repository/1 with valid data creates a repository" do
      assert {:ok, %Repository{} = repository} = Github.create_repository(@valid_attrs)
      assert repository.name == "some name"
      assert repository.owner == "some owner"
    end

    test "create_repository/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Github.create_repository(@invalid_attrs)
    end

    test "update_repository/2 with valid data updates the repository" do
      repository = repository_fixture()

      assert {:ok, %Repository{} = repository} =
               Github.update_repository(repository, @update_attrs)

      assert repository.name == "some updated name"
      assert repository.owner == "some updated owner"
    end

    test "update_repository/2 with invalid data returns error changeset" do
      repository = repository_fixture()
      assert {:error, %Ecto.Changeset{}} = Github.update_repository(repository, @invalid_attrs)
      assert repository == Github.get_repository!(repository.id)
    end

    test "delete_repository/1 deletes the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{}} = Github.delete_repository(repository)
      assert_raise Ecto.NoResultsError, fn -> Github.get_repository!(repository.id) end
    end

    test "change_repository/1 returns a repository changeset" do
      repository = repository_fixture()
      assert %Ecto.Changeset{} = Github.change_repository(repository)
    end
  end
end
