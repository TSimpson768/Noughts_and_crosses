require_relative '../lib/game'

describe Game do
  describe '#over?' do
    subject(:empty_game) { described_class.new }
    it 'Returns false for an empty board' do
      
      expect(empty_game).not_to be_over
    end
    context 'when a game is in progress' do
      subject(:in_progress_game) { described_class.new }
      it 'Returns false' do
      in_progress_game.instance_variable_set(:@board, [['X',nil, nil],[nil, 'O',nil],['X',nil,nil]])
      expect(in_progress_game).not_to be_over
      end
    end

    context 'when a game is over' do
      subject(:won_game) { described_class.new }
      it 'returns true when a game has been won' do
        won_game.instance_variable_set(:@board, [['X', 'X', 'X'],[nil, 'O', nil], ['O', nil, nil]])
        expect(won_game).to be_over
      end
    end

    context 'when board is filled' do
      subject(:full_game) { described_class.new }
      it 'returns true when the board has been filled' do
        full_game.instance_variable_set(:@board, [['O', 'O', 'X'],
                                                  ['X', 'X', 'O'],
                                                  ['O', 'X', 'X']])
        expect(full_game).to be_over
      end
    end

  end

  describe '#board_full' do
    context 'when board is empty' do
      subject(:empty_game) { described_class.new }
      it 'returns false for an empty board' do
       expect(empty_game).not_to be_board_full
      end
    end

    context 'when board is full' do
      subject(:full_game) { described_class.new }
      it 'returns true' do
        full_game.instance_variable_set(:@board, [['O', 'O', 'X'],
                                                  ['X', 'X', 'O'],
                                                  ['O', 'X', 'X']])
        expect(full_game).to be_board_full
      end
    end

  end

  describe '#update_player' do
    context 'when @current_player == @player1' do
      subject(:p1_game) { described_class.new }
      it 'sets current player to @player2' do
        player2 = p1_game.instance_variable_get(:@player2)
        p1_game.update_player
        updated_player = p1_game.instance_variable_get(:@current_player)
        expect(updated_player).to equal(player2)
      end
    end

    context 'when @current_player==@player2' do
      subject(:p2_game) { described_class.new }
      before do
        player2 = p2_game.instance_variable_get(:@player2)
        p2_game.instance_variable_set(:@current_player, player2)
      end
      it 'sets current player to @player1' do
        player1 = p2_game.instance_variable_get(:@player1)
        p2_game.update_player
        updated_player = p2_game.instance_variable_get(:@current_player)
        expect(updated_player).to equal(player1)
      end
    end
  end

  describe '#turn' do
    subject(:game_turn) { described_class.new }
    context 'when parse_input returns a valid move' do
      before do
        allow(game_turn).to receive(:parse_input).and_return([0, 0])
        allow(game_turn).to receive(:valid_move?).and_return(true)
      end

      it 'updates that space on the board' do
        current_symbol = game_turn.instance_variable_get(:@current_player).symbol
        game_turn.turn
        updated_board = game_turn.instance_variable_get(:@board)
        expect(updated_board[0][0]).to eq(current_symbol)
      end

      it 'loops only once' do
        error_message = 'That space is occupied!'
        expect(game_turn).not_to receive(:puts).with(error_message)
        game_turn.turn
      end
    end

    context 'when parse_input returns 2 invalid moves, then a valid move' do
      before do
        game_turn.instance_variable_set(:@board, [[nil, 'X', 'O'],
                                                  ['X', nil, nil],
                                                  ['O', nil, nil]])
        allow(game_turn).to receive(:parse_input).and_return([1, 0], [0, 1], [1,1])
        allow(game_turn).to receive(:valid_move?).and_return(false, false, true)
        allow(game_turn).to receive(:puts)
      end
      it 'puts error message twice' do
        error_message = 'That space is occupied!'
        expect(game_turn).to receive(:puts).with(error_message).twice
        game_turn.turn
      end

      it 'updates the valid space' do
        current_symbol = game_turn.instance_variable_get(:@current_player).symbol
        game_turn.turn
        updated_board = game_turn.instance_variable_get(:@board)
        expect(updated_board[1][1]).to eq(current_symbol)
      end
    end
    
  end

  describe '#valid_move' do
    it 'returns true for an empty space' do
      empty_game = described_class.new 
      is_valid = empty_game.valid_move?(1, 1)
      expect(is_valid).to be true
    end

    it 'returns false for an occupied space' do
      occupied_game = described_class.new
      occupied_game.instance_variable_set(:@board,[[nil, nil, 'X'],
                                                   [nil, nil, nil],
                                                   [nil, nil, nil]])
      is_valid = occupied_game.valid_move?(2, 0)
      expect(is_valid).to be false
      
    end
  end

  describe '#parse_input' do
    subject(:game_parse) { described_class.new }
    invalid_message = 'Invalid input'
    context 'with a valid input' do
      before do
        allow(game_parse).to receive(:gets).and_return("c1\n")
      end
      it 'does not puts anyting' do
        expect(game_parse).not_to receive(:puts).with(invalid_message)
        game_parse.parse_input
        
      end
    end

    before do
      allow(game_parse).to receive(:gets).and_return("D5\n", "Pi42\n", "A1\n")
    end
    context 'with an invalid, invalid, then valid input' do
      it 'loops twice' do
        expect(game_parse).to receive(:puts).with(invalid_message).twice
        game_parse.parse_input
      end
    end
  end

  describe '#process_input' do
    subject(:game_process) { described_class.new }
    context 'when A1 is input' do
      it 'returns [0, 0]' do
        input = 'A1'
        output = game_process.process_input(input)
        expected = [0, 0]
        expect(output).to eq(expected)
      end
    end

    context 'when c3 is input' do
      it 'returns [2, 2]' do
        input = 'c3'
        output = game_process.process_input(input)
        expected = [2, 2]
        expect(output).to eq(expected)
      end
    end

    context 'when B1 is input' do
      it 'returns [1, 0]' do
        input = 'B1'
        output = game_process.process_input(input)
        expected = [1, 0]
        expect(output).to eq(expected)
      end
    end
  end

  describe '#play' do
    subject(:game_play) { described_class.new }
    before do
      allow(game_play).to receive(:print_board)
      allow(game_play).to receive(:turn)
      allow(game_play).to receive(:update_player)
    end
    context 'when over?' do
      before do
        allow(game_play).to receive(:over?).and_return(true)
      end
      it 'Breaks after one turn' do
        expect(game_play).not_to receive(:update_player)
        game_play.play
      end
    end

    context 'when over? = false, false, false, false, true' do
      before do
        allow(game_play).to receive(:over?).and_return(false, false, false, false, true)
      end
      it 'Loops 4 times, then breaks' do
        expect(game_play).to receive(:update_player).exactly(4).times
        game_play.play
      end
    end
  end
end