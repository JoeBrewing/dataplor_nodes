# Setup

# DB
(I know I could have done these with a migration but I didn't want to take any longer with this than I already have)\
CREATE ROLE dataplor_nodes WITH LOGIN PASSWORD 'dataplor';\
ALTER ROLE dataplor_nodes CREATEDB;\
CREATE EXTENSION IF NOT EXISTS ltree;

# RAILS
git clone https://github.com/JoeBrewing/dataplor_nodes/ \
rake db:migrate\
rake seed_dataplor_node_data:seed\
rake seed_dataplor_node_data:seed_paths
