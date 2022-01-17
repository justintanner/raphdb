module OpenFixtureHelper
  def open_fixture(filename)
    File.open(Rails.root.join('test', 'fixtures', 'files', filename))
  end
end
