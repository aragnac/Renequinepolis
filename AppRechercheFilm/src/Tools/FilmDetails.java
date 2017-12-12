package Tools;

import java.sql.Date;
import java.util.List;
import java.util.Vector;

public class FilmDetails {
    private int Id;
    private String Titre;
    private String TitreOriginal;
    private String Status;
    private Date DateSortie;
    private int Vote_Count;
    private double Moyenne_Vote;
    private String Certification;
    private long Duree;
    private Vector<String> LActor;
    private Vector<String> LDirector;
    private Vector<String> LGenre;

    public int getId() {
        return Id;
    }

    public String getTitre() {
        return Titre;
    }

    public String getTitreOriginal() {
        return TitreOriginal;
    }

    public String getStatus() {
        return Status;
    }

    public Date getDateSortie() {
        return DateSortie;
    }

    public int getVote_Count() {
        return Vote_Count;
    }

    public double getMoyenne_Vote() {
        return Moyenne_Vote;
    }

    public String getCertification() {
        return Certification;
    }

    public long getDuree() {
        return Duree;
    }

    public Vector<String> getLActor() {
        return LActor;
    }

    public Vector<String> getLDirector() {
        return LDirector;
    }

    public Vector<String> getLGenre() {
        return LGenre;
    }

    public FilmDetails() {
        Id = -1;
        Titre = "";
        TitreOriginal = "";
        Status = "";
        DateSortie = null;
        Vote_Count = -1;
        Moyenne_Vote = -1;
        Certification = "";
        Duree = -1;
        LActor = null;
        LDirector = null;
        LGenre = null;
    }

    public FilmDetails(int id, String titre, String titreOriginal, String status, Date dateSortie, int vote_Count, double moyenne_Vote, String certification, long duree, Vector<String> LActor, Vector<String> LDirector, Vector<String> LGenre) {
        Id = id;
        Titre = titre;
        TitreOriginal = titreOriginal;
        Status = status;
        DateSortie = dateSortie;
        Vote_Count = vote_Count;
        Moyenne_Vote = moyenne_Vote;
        Certification = certification;
        Duree = duree;
        this.LActor = LActor;
        this.LDirector = LDirector;
        this.LGenre = LGenre;
    }
}
