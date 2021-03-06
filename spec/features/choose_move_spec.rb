feature "FEATURE: Choose move" do
  context "Two human players" do
    before(:each) do
      play_two_player
    end
    scenario "player 1 can choose their move" do
      choose("p1_choice", {:option => "lizard"})
      click_button('p1_move')
      p1_hider_class = page.find('#p1_move_hider')[:class].include?('hidden-xs-up')
      expect(p1_hider_class).to be false
    end
    scenario "player 2 can choose their move" do
      choose("p1_choice", {:option => "lizard"})
      click_button('p1_move')
      choose("p2_choice", {:option => "spock"})
      click_button('p2_move')
      expect(page).to have_css("#results-wrapper")
    end
  end

  context "One human player vs computer" do
    scenario "Player 2's move is generated automatically" do
      play_vs_computer
      choose("p1_choice", {:option => "lizard"})
      click_button('p1_move')
      expect(page).to have_css("#results-wrapper")
    end
  end

end
