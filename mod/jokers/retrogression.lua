SMODS.Joker {
    key = "retrogression",
    atlas = "retrogression1",
    pos = { x = 0, y = 0 },
    config = { extra = {} },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
    end,
    calculate = function(self, card, context)
        if context.skip_blind then
			SMODS.calculate_context({ setting_blind = true, blind = G.GAME.round_resets.blind })
			SMODS.last_hand = SMODS.last_hand or { scoring_hand = {}, full_hand = {} }
			G.E_MANAGER:add_event(Event({
				func = function()
					SMODS.calculate_context({
						end_of_round = true,
						game_over = false,
						beat_boss = G.GAME.blind.boss,
						scoring_hand = SMODS.last_hand.scoring_hand,
						scoring_name = SMODS.last_hand.scoring_name,
						full_hand = SMODS.last_hand.full_hand,
					})
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.3,
				func = function()
					if G.GAME.round_resets.temp_handsize then
						G.hand:change_size(-G.GAME.round_resets.temp_handsize)
						G.GAME.round_resets.temp_handsize = nil
					end
					if G.GAME.round_resets.temp_reroll_cost then
						G.GAME.round_resets.temp_reroll_cost = nil
						calculate_reroll_cost(true)
					end

					reset_idol_card()
					reset_mail_rank()
					reset_ancient_card()
					reset_castle_card()
					for _, mod in ipairs(SMODS.mod_list) do
						if mod.reset_game_globals and type(mod.reset_game_globals) == "function" then
							mod.reset_game_globals(false)
						end
					end
					for k, v in ipairs(G.playing_cards) do
						v.ability.discarded = nil
						v.ability.forced_selection = nil
					end
					return true
				end,
			}))
			for _, j in ipairs(G.jokers.cards) do
				local money = j:calculate_dollar_bonus()
				if money then
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.3,
						func = function()
							ease_dollars(money)
							SMODS.calculate_effect({
								colour = G.C.MONEY,
								message = localize("$") .. money,
							}, j)
							return true
						end,
					}))
				end
			end
		end
    end,
}