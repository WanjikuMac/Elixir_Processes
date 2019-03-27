defmodule Prac.Scores do
  def start do
    Agent.start_link(fn -> %{score: 0, best_score: 0, previous_score: "never", lifetime_score: 0 } end)
  end

  def put(pid, key, value) do
    save_score(pid)
    best_score(pid, value)
    Agent.update(pid, fn(state) ->  Map.put(state, key, value) end)
    calculate_scores(pid, key, value)
  end

  def get(pid, key) do
    Agent.get(pid, &Map.get(&1, key))
  end

  def show(pid) do
    Agent.get(pid, fn state -> state end)
  end

  defp calculate_scores(pid, key, value) do
    case key do
      :score ->
        #calculate lifetime_score
        overall_score = Agent.get(pid, &Map.get(&1, :lifetime_score)) + value

        # update state
        Agent.update(pid, &Map.put(&1, :lifetime_score, overall_score))

      _ ->
        :ok
    end
  end

  defp save_score(pid) do
    scores_bfr_update = Agent.get(pid, &Map.get(&1, :score))
    Agent.update(pid, &Map.put(&1, :previous_score, scores_bfr_update))
  end

  defp best_score(pid, value) do
    case Agent.get(pid, fn(state) -> Map.get(state, :best_score)end) > value do
      false ->
        Agent.update(pid, fn(state) ->Map.put(state, :best_score, value)end)
      true ->
        Agent.get(pid, fn(state) -> Map.get(state, :best_score)end)
    end
  end
end
