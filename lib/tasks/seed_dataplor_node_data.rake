require 'roo'

# Seeds dataplore node data from the provided CSV file.

namespace :seed_dataplor_node_data do
  # The name of the file to use.
  FILENAME = 'dataplor_nodes.csv'

  # The name of the sheet to use.
  SHEETNAME = 'default'

  # Mapping from the sheet header to the node table column.
  OPTS = {
    'node_id': 'id',
    'parent_id': 'parent_id'
  }

  task seed: :environment do
    # Gets the file path as a string.
    in_path = Rails.root.join('data', FILENAME).to_s

    # Opens the spreadsheet with roo.
    file = Roo::Spreadsheet.open(in_path)

    # Gets the sheet.
    sheet = file.sheet(SHEETNAME)

    # Loop through each row in the file.
    sheet.each(OPTS) do |row_hash|
      # Go to the next row if the current row is the header.
      next if row_hash[:node_id] == 'id'

      # We want to get the path if it the `parent_id` value is 'nil' because that
      # means this is a root node and we need to set the path.
      path = row_hash[:parent_id].blank? ? row_hash[:node_id] : nil
      
      # Create our new node record.
      Node.create!(
        node_id: row_hash[:node_id],
        parent_id: row_hash[:parent_id],
        path: path
      )
    end
  end

  task seed_paths: :environment do
    Node.set_node_paths(Node.all.to_a)
  end
end