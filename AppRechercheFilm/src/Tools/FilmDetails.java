package Tools;

import java.math.BigDecimal;
import java.sql.Blob;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
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
    private Blob Poster;
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

    public Blob getPoster() {
        return Poster;
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

    public static FilmDetails fromList(List<List<Object>> l) {
        List<Object> list = l.get(0);
        Vector<String> actor = new Vector<>();
        for (Object o : l.get(1)) actor.add(o.toString());
        Vector<String> director = new Vector<>();
        for (Object o : l.get(2))
            director.add(o.toString());
        Vector<String> genre = new Vector<>();
        for (Object o : l.get(3))
            genre.add(o.toString());

        return new FilmDetails(((BigDecimal) list.get(0)).intValue(),
                list.get(1).toString(),
                list.get(2).toString(),
                list.get(3).toString(),
                new Date(((Timestamp) list.get(4)).getTime()),
                ((BigDecimal)list.get(5)).intValue(),
                ((BigDecimal)list.get(6)).intValue(),
                list.get(7).toString(),
                ((BigDecimal)list.get(8)).intValue(),
                (Blob) list.get(9),
                actor,
                director,
                genre);
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
        Poster = null;
        LActor = null;
        LDirector = null;
        LGenre = null;
    }

    public FilmDetails(int id, String titre, String titreOriginal, String status, Date dateSortie, double moyenne_Vote, int vote_Count, String certification, long duree, Blob poster, Vector<String> LActor, Vector<String> LDirector, Vector<String> LGenre) {
        Id = id;
        Titre = titre;
        TitreOriginal = titreOriginal;
        Status = status;
        DateSortie = dateSortie;
        Vote_Count = vote_Count;
        Moyenne_Vote = moyenne_Vote;
        Certification = certification;
        Duree = duree;
        Poster = poster;
        this.LActor = LActor;
        this.LDirector = LDirector;
        this.LGenre = LGenre;
    }
}
