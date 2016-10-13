class FamilyNotesController < ApplicationController
  def create
    @note = FamilyNote.new(family_note_params)
    @note.user_id = current_user.id
    if @note.save
      flash[:success] = 'Note was created successfully.'
    else
      flash[:error] = "Couldn't create the note."
    end

    redirect_to controller: 'families', action: 'show', id: @note.family.id, active_tab: 'notes'
  end

  private

  def family_note_params
    params.require(:family_note).permit(:family_id, :category, :content)
  end
end
