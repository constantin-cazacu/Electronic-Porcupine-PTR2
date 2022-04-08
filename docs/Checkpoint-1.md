# Electric-Porcupine-PTR2
## The Task
The focus of this laboratory work is to expand on the notion of processing tweets and loading
streaming data into a database. You should start by continuing what you did in the first lab and
implementing the ability to spawn multiple worker pools. You will need two pools of workers
which will be calculating the Sentiment Score and Engagement Ratio of tweets respectively.
Following, the results of these calculations should be reconnected with the tweets, grouped in
batches and, finally, saved to a database.

## Checkpoint #1
### System Architecture Diagram
![diagram.png](system-architecture.png)

### Data Flow
![data_flow.png](data-flow.png)

### Actors' Endpoints
![actors_table.png](actor-endpoints-table.png)

### Language of Choice: Elixir
### Libraries: