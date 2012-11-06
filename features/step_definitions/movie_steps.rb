# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert page.body.index(e1) < page.body.index(e2)
 # response.body.should =~ /#{e1}.*#{e2}/m
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |rating|
    rating = "ratings_" + rating
    if uncheck
      uncheck(rating)
    else
      check(rating)
    end
  end
end

When /^I (un)?check all the ratings$/ do | uncheck |
  Movie.all_ratings.each do | rating  |
    rating = "ratings_" + rating
    if uncheck
      uncheck(rating)
    else
      check(rating)
    end
  end
end

Then /I should (not )?see the following: (.*)/ do |not_visible, full_text|
  full_text.split(", ").each do |text|
    if page.respond_to? :should
      if not not_visible
        page.should have_content(text)
      else
        page.should_not have_content(text)
      end
    else
      if not not_visible
        assert page.has_content?(text)
      else
        assert (not page.has_content?(text))
      end
    end
  end
end

Then /I should see (none|all) of the movies/ do |filter|
  db_size = 0
  db_size = Movie.all.size if filter == "all"
  page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_size} ]")
end
