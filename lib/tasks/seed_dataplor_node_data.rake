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

      # Create a new `Node` record using the row hash.
      Node.create!(row_hash)
    end
  end
end